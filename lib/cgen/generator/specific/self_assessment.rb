class CGen::Generator::SelfAssessment < CGen::Generator::BasicGenerator

  def initialize(param, data, lang)
    super(param, data, lang)
  end

  def generate
    get_self_assessment(get_value(param))
  end

  protected

  def get_self_assessment(context)
    context.merge!({'titles' => get_value('titles')})

    input = <<-CODE

    \\cvitem{<%= @titles['S_5']['self_assessment'] %>}

    {
    \\begin{table}
    \\scriptsize
    \\begin{tabular}{l|l|l|l|l|l|l|l|l|l|l}

      \\multicolumn{1}{c|}{<%= ' ' %>} &
      \\multicolumn{4}{|c|}{\\textbf{<%= @titles['S_5']['understanding'] %>}} &
      \\multicolumn{4}{|c|}{\\textbf{<%= @titles['S_5']['speaking'] %>}} &
      \\multicolumn{2}{|c|}{\\textbf{<%= @titles['S_5']['writing'] %>}} \\\\

      \\multicolumn{1}{c|}{<%= ' ' %>} &
      \\multicolumn{2}{|c|}{<%= @titles['S_5']['listening'] %>} &
      \\multicolumn{2}{|c|}{<%= @titles['S_5']['reading'] %>} &
      \\multicolumn{2}{|c|}{<%= @titles['S_5']['spoken_interaction'] %>} &
      \\multicolumn{2}{|c|}{<%= @titles['S_5']['spoken_production'] %>} &
      \\multicolumn{2}{|c|}{<%= @titles['S_5']['written_production'] %>} \\\\
      \\hline

      <% @languages.each do |language| %>
        \\hline
        \\textbf{<%= language['name'] %>} &
        <%= language['listening']['level'] %> &
        <%= language['listening']['description'] %> &
        <%= language['reading']['level'] %> &
        <%= language['reading']['description'] %> &
        <%= language['spoken_interaction']['level'] %> &
        <%= language['spoken_interaction']['description'] %> &
        <%= language['spoken_production']['level'] %> &
        <%= language['spoken_production']['description'] %> &
        <%= language['written_production']['level'] %> &
        <%= language['written_production']['description'] %> \\\\
      <% end %>
      \\hline

    \\end{tabular}
    \\end{table}
    }

    CODE

    evaluate(input, context).gsub(/^\s+/,'').gsub(/\n/,'') + "\n\n"
  end

end
