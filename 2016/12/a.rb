require 'epitools'

# file = "test.txt"
file = "input.txt"

insts = File.read(file).each_line.map do |line|
  line.strip.split.map { |token| token.number? ? token.to_i : token }
end

regs      = ('a'..'d').zip([0]*4).to_h
regs["c"] = 1
pc        = 0
step      = 0


update_frequency = 215721

loop do
  inst = insts[pc]

  if step % update_frequency == 0
    p step: step, pc: pc, regs: regs, inst: inst
  end

  unless inst
    puts "END: #{regs.inspect}"
    break
  end

  # cpy x y copies x (either an integer or the value of a register) into register y.
  # inc x increases the value of register x by one.
  # dec x decreases the value of register x by one.
  # jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.

  op, x, y = inst

  case op
  when "cpy"
    x = regs[x] if x.is_a? String
    regs[y] = x
    pc += 1
  when "inc"
    regs[x] += 1
    pc += 1
  when "dec"
    regs[x] -= 1
    pc += 1
  when "jnz"
    if regs[x] != 0
      pc += y
    else
      pc += 1
    end
  end

  step += 1
end
