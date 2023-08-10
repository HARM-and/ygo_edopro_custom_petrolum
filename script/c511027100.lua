-- Esprit Caffey

local s,id=GetID()
function s.initial_effect(c)
    -- Effet de cimetière
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    
    -- Effets pendant ce tour
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_HAND)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCost(s.cost)
    e3:SetCountLimit(1,id+1)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end

-- Effet de cimetière : ajouter un monstre "Caffey" du cimetière à la main
function s.thfilter(c)
    return c:IsSetCard(0xcaf) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- Effets pendant ce tour
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
    e:SetLabel(opt)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local opt=e:GetLabel()
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSetCard,0xcaf),tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
        if opt==0 then
            -- Effet pour les monstres Synchro "Caffey"
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(aux.tgoval)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1,true)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
            e2:SetValue(s.indval)
            tc:RegisterEffect(e2,true)
        else
            -- Effet pour les monstres Xyz "Caffey"
            if tc:IsType(TYPE_XYZ) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(800)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e1,true)
            end
        end
    end
end

