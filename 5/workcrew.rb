class WorkCrew

  def initialize(num_workers=nil)
    @workers = (num_workers || cpus).times.map { |n| Worker.new(n) }
  end

  def cpus
    if File.readable?("/proc/cpuinfo")
      IO.read("/proc/cpuinfo").scan(/^processor/).size
    else
      raise "Error: can't read /proc/cpuinfo"
    end
  end

  def process(data, chunk_size=nil, &block)
    Enumerator.new do |y|
      chunk_size ||= data.size/@workers.size
      results = []

      data.each_slice(chunk_size).each_slice(@workers.size) do |chunks|
        threads = @workers.zip(chunks).map do |worker, chunk|
          worker.process(chunk, &block)
        end

        threads.each(&:join)
        threads.each { |t| y << t[:result] }
      end
    end
  end

end

class Worker

  def initialize(n)
    @n = n
  end

  def process(data, &block)
    parent_read, child_write = IO.pipe

    fork do
      result = block.call(data)
      child_write.write Marshal.dump(result)
      child_write.close
    end

    Thread.new do
      puts "#{self} started"
      Thread.current[:result] = Marshal.load(parent_read.read)
      parent_read.close
      puts "#{self} finished"
    end
  end

end

crew = WorkCrew.new(1)
y = crew.process(1..100) { |chunk| chunk.select { |n| n % 7 } }
p y.first
p :done
