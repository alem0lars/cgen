module CurriculumGenerator
  module Generator
    class Education < BasicGenerator

      def initialize(param, data, lang)
        super(param, data, lang)
      end

      def generate
        value = get_value(param)
        value.collect do |elem|
          get_education(elem)
        end.join('')
      end

      protected

      def get_education(context)
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

        {<%= @title.nil? ? '' : @title %>}

        {}{}{}

        {\\begin{itemize}

        <% if @qualification %>
          \\item \\textit{<%= @titles['S_4']['qualification'] %>}: <%= @qualification %>
        <% end %>

        <% if @organisation %>
          \\item \\textit{<%= @titles['S_4']['organisation'] %>}: <%= @organisation %>
        <% end %>

        <% if @level %>
          \\item \\textit{<%= @titles['S_4']['level'] %>}: <%= @level %>
        <% end %>

        <% if @lessons %>
          \\item \\textit{<%= @titles['S_4']['lessons'] %>}: <%= @lessons %>
        <% end %>

        <% if @validity %>
          \\item \\textit{<%= @titles['S_4']['validity'] %>}: <%= @validity %>
        <% end %>

        <% if @location %>
          \\item \\textit{<%= @titles['S_4']['location'] %>}: <%= @location %>
        <% end %>

        <% if @teacher %>
          \\item \\textit{<%= @titles['S_4']['teacher'] %>}: <%= @teacher %>
        <% end %>

        <% if @skills_covered %>

          <% unless @skills_covered.is_a?(Array) %>
            <% @skills_covered = Array[@skills_covered] %>
          <% end %>

          <% @skills_covered.compact! %>

          <% if @skills_covered.length > 0 %>

            \\item \\textit{<%= @titles['S_4']['skills_covered'] %>}:
            \\begin{itemize}

            <% @skills_covered.each do |skill_covered| %>
              \\item <%= skill_covered %>
            <% end %>

            \\end{itemize}

          <% end %>

        <% end %>

        \\end{itemize}}

        CODE

        evaluate(input, context).gsub(/^\s+/,'').gsub(/\n/,'') + "\n\n"
      end

    end
  end
end
