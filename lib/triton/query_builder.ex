defmodule Triton.QueryBuilder do
  def build_query(type, module, value) do
    quote do
      existing_query = Triton.QueryBuilder.query_list(unquote(module))
      existing_type = unquote(type)

      case Keyword.get(existing_query, existing_type) do
        # Existing query don't exist yet, just use old logic
        nil -> [ { existing_type, unquote(value)} | existing_query ]
        existing_value -> 
          new_value = Keyword.merge(existing_value, unquote(value))
          Keyword.merge(existing_query, [ {existing_type, new_value} ])
      end
    end
  end

  def query_list(module) do
    case is_list(module) do

      false -> [
        {:__table__, Module.concat(module, Metadata).__struct__.__table__},
        {:__schema__, Module.concat(Module.concat(module, Metadata).__struct__.__schema_module__, Table).__struct__ }
      ]
      true -> module
    end
  end
end
