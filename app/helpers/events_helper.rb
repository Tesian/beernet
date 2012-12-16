module EventsHelper

  def timetable_select(ff, var, list, var_time)
    if var_time
      ff.select var, options_for_select(list.to_a, var_time.method(var.singularize).call)
    else
      ff.select var, list.to_a
    end
  end

end
