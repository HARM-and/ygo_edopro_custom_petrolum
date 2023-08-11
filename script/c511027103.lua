-- Salon de Caffey
local s,id=GetID()
function s.initial_effect(c)
    -- Effet d'activation
    aux.AddFieldSpell(c,s.spellsummon)
end

-- Activation de l'effet
function s.spellsummon(e,c)
    local tp=c:GetControler()
    local seq=c:GetSequence()
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5-seq)
    return fc and fc:IsSetCard(0xCAF) and (fc:IsType(TYPE_SYNCHRO) or fc:IsType(TYPE_XYZ))
end

-- Effets lors de l'Invocation Spéciale
function s.syncon(e,tp,eg,ep,ev,re,r,rp)
    local fc=e:GetHandler():GetFlagEffectLabel(id)
    return fc and fc==1 and e:GetHandler():IsControler(tp) and e:GetHandler():IsLocation(LOCATION_SZONE)
end

function s.synop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_CARD,0,id)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end

function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    local fc=e:GetHandler():GetFlagEffectLabel(id)
    return fc and fc==2 and e:GetHandler():IsControler(tp) and e:GetHandler():IsLocation(LOCATION_SZONE)
end

function s.xyxtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.Draw(tp,1,REASON_EFFECT)
end
