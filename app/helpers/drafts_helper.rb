module DraftsHelper
  def current_team_name(draft)
    if draft.current_team
      draft.current_team.name
    else
      ""
    end
  end
  
  def current_nominator(draft)
    if draft.nominator
      draft.nominator.name
    else
      ""
    end
  end
end
