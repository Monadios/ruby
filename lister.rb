def sieve(max)
  primes = (0..max).to_a
  primes[0] = primes[1] = nil
  primes.each do |p|
    next unless p
    break if p*p > max
    (p*p).step(max,p) { |m| primes[m] = nil }
  end
  primes.compact
end

def fib(n)
  fib0,fib1,fib = [0,1,0]

  (1..n).each do |i|
    fib = fib0 + fib1
    fib0 = fib1
    fib1 = fib
  end

  return fib
end
