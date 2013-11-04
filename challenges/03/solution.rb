class Object

  def thread(*operations)
    operations.reduce(self) do |result, operation|
      result = if operation.kind_of?(Proc)
        operation.call(result)
      else
        result.send(operation)
      end
    end
  end

end