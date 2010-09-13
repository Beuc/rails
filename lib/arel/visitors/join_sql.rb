module Arel
  module Visitors
    ###
    # This class produces SQL for JOIN clauses but omits the "single-source"
    # part of the Join grammar:
    #
    #   http://www.sqlite.org/syntaxdiagrams.html#join-source
    #
    # This visitor is used in SelectManager#join_sql and is for backwards
    # compatibility with Arel V1.0
    class JoinSql < Arel::Visitors::ToSql
      def visit_Arel_Nodes_SelectCore o
        o.froms.grep(Nodes::Join).map { |x| visit x }.join ', '
      end

      def visit_Arel_Nodes_StringJoin o
        [
          (visit o.left if Nodes::Join === o.left),
          visit(o.right)
        ].join ' '
      end

      def visit_Arel_Nodes_OuterJoin o
        "LEFT OUTER JOIN #{visit o.right} #{visit o.constraint}"
      end

      def visit_Arel_Nodes_InnerJoin o
        "INNER JOIN #{visit o.right} #{visit o.constraint if o.constraint}"
      end
    end
  end
end
