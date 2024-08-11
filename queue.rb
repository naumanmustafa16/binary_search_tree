class Queue
  attr_reader :data
  def initialize
    @data = []
  end
  
  def enqueue(element)
    @data << element
  end

  def dequeue
    @data.shift
  end

  def read
    @data.shift
  end

end

q1 = Queue.new
q1.enqueue(5)
q1.enqueue(10)
q1.dequeue
p q1.dequeue
p q1.data.empty?