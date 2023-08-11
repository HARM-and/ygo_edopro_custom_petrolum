-- Salon de Caffey
local s,id=GetID()
function s.initial_effect(c)
    -- Activation de l'effet
    aux.AddFieldSpell(c,s.spellsummon)
    -- Effets sur l'Invocation Spéciale
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCondition(s.syncon)
    e1:SetOperation(s.synop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCondition(s.xyzcon)
    e2:SetOperation(s.xyzop)
    c:RegisterEffect(e2)
end

-- Activation de l'effet
function s.spellsummon(e,c)
    local tp=e:GetHandlerPlayer()
    local seq=c:GetSequence()
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5-seq)
    return fc and fc:IsSetCard(0xCAF) and (fc:IsType(TYPE_SYNCHRO) or fc:IsType(TYPE_XYZ))
end

-- Effets sur l'Invocation Spéciale
function s.syncon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    return ec:IsControler(tp) and ec:IsType(TYPE_SYNCHRO) and ec:IsSetCard(0xCAF)
end

function s.synop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end

function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    return ec:IsControler(tp) and ec:IsType(TYPE_XYZ) and ec:IsSetCard(0xCAF)
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.Draw(tp,1,REASON_EFFECT)
end
