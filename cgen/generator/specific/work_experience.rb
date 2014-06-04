class CGen::Generator::WorkExperience < CGen::Generator::BasicGenerator

  def initialize(param, data, lang)
    super(param, data, lang)
  end

  def generate
    value = get_value(param)
    value.collect do |elem|
      get_work_experience(elem)
    end.join("\n")
  end

  protected

  def get_work_experience(context)

    context.merge!({'titles' => get_value('titles')})

    input = <<-CODE

    \\cventry

    <% if @date.nil? %>
      {}
    <% elsif @date.is_a?(Hash) && @date.has_key?('from') && @date.has_key?('to') %>
      {<%= @date['from'] %>\\\\<%= @date['to'] %>}
    <% else %>
      {<%= @date %>}
    <% end %>

    {<%= @occupation.nil? ? '' : @occupation %>}

    <% if @employer_name %>

      {
      <%= @employer_name %>
      <% if @type_of_business %>
        (<%= @type_of_business %>)
      <% end %>
      }

      <% if @employer_address %>
        {<%= @employer_address %>}
      <% end %>

    <% end %>

    {}

    {
    <% if @main_activities %>

      <% unless @main_activities.is_a?(Array) %>
        <% @main_activities = Array[@main_activities] %>
      <% end %>

      <% @main_activities.compact! %>

      <% if @main_activities.length > 0 %>

        \\textit{<%= @titles['S_3']['main_activities'] %>}:
        \\begin{itemize}

        <% @main_activities.each do |main_activity| %>
          \\item <%= main_activity %>
        <% end %>

        \\end{itemize}

      <% end %>

    <% end %>
    }

    CODE

    evaluate(input, context).gsub(/^\s+/,'').gsub(/\n/,'') + "\n\n"
  end

end
