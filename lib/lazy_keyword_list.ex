defmodule LazyKeywordList do
  defmacro sigil_k({:<<>>, _line, [term_string]}, _modifiers) do
    {terms, default} = terms_and_default(term_string)

    validate_names(terms)

    keyword_list(terms, default)
  end

  defp terms_and_default(term_string) do
    terms = String.split(term_string)
    case Enum.at(terms, -2) do
      "|" -> split_terms_and_default(terms)
      _   -> {terms, nil}
    end
  end

  defp keyword_list(terms, nil) do
    Enum.map(terms, fn(term) ->
      atom_term = String.to_atom(term)
      {atom_term, Macro.var(atom_term, nil)}
    end)
  end
  defp keyword_list(terms, default) do
    Enum.map(terms, fn(term) ->
      {String.to_atom(term), default}
    end)
  end

  defp split_terms_and_default(terms) do
    {raw_default, terms} = List.pop_at(terms, -1)
    {_, terms} = List.pop_at(terms, -1)
    {default, []} = Code.eval_string(raw_default)
    {terms, default}
  end

  defp validate_names(terms) do
    Enum.each terms, fn(term) ->
      unless term =~ ~r/^[a-z]{1}/ do
        raise ArgumentError,
          "#{term} invalid: names must start with a lower case letter"
      end
    end
  end
end

