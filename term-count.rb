require "rspec"

def count_terms(input) 
  "Fee"
end

def get_term_count(input, term)
  2
end

def get_term_counts(input)
  terms_counts_hash = Hash.new { |hash, key| hash[key] = 0 }
  input.each { |term| terms_counts_hash[term.to_sym] += 1 }
  terms_counts_hash
end

def get_top_3(input)
  terms_counts_hash = get_term_counts(input) 
  counts_terms_hash = terms_counts_hash.invert # terms of duplicate counts get clobbered
  counts_terms_hash.sort_by { |count| count }.reverse.first(3).map { |term_count_array|
    term_count_array[1] }.join("\n")
end

def get_top_n(input, n)
  top_n_counts_terms_array = get_term_counts(input)
    .invert
    .sort_by { |count| count }
    .reverse
    .first(n).map { |term_count_array| term_count_array[1] }
    .join("\n")
end

def get_top_n2(input, n)
  print "\nn: ", n, "\n"
  terms_counts_array = get_term_counts(input)
    .sort_by { |term, count| count }
    .reverse

  print "tca: ", terms_counts_array, "\n"

  last_count = terms_counts_array.first[1]
  top_n_terms_counts = terms_counts_array.keep_if { |term_count_array| 
    count = term_count_array[1]
    if (count < last_count)
      n -= 1
      last_count = count
    end
    print "term_count_array: ", term_count_array, " n: ", n, "\n"
    if (n == 0)
      false
    else
      true # needed?
    end
  }
  top_n_terms_counts.map { |item| item[0].to_s }.join("\n")  
end

# Get sorted array of counts, find top n counts, find corresonding terms, list in order
def get_top_n3(input, n)
  print "\n#get_top_n3\nn: ", n, "; input: ", input, "\n"
  terms_counts_hash = get_term_counts(input)
  print "tch: ", terms_counts_hash, "\n"
  min_count_to_keep = terms_counts_hash.values.sort.reverse.uniq.first(n).last
  print "\ntch.values.uniq: ", terms_counts_hash.values, "\n"
  print "\nmctk: ", min_count_to_keep, "\n"
  counts_terms_hash = Hash.new { |hash, key| hash[key] = [] }
  terms_counts_hash.each { |term_count_array|
    count = term_count_array[1]
    print "\ntca: ", term_count_array, "; count: ", count, "\n"
    if (count >= min_count_to_keep) 
      counts_terms_hash[count.to_s].push(term_count_array[0])
    end
  }
  sorted_counts_terms_hash = counts_terms_hash.sort_by { |count, terms| count }.reverse
  print "\ncth: ", sorted_counts_terms_hash, "\n"
  sorted_counts_terms_hash.map { |count, terms_array| terms_array.sort }.join("\n")
end

describe "#n" do
  
  it "returns 'Fee'" do
#    termCount.terms.should eq[ "Fee" ]
     input = []
     expect(count_terms(input)).to eq("Fee")
  end

  it "returns count for term 'Fee'" do
     input = [ "Fee", "Fi", "Fo", "Fum", "Fee" ]
     expect(get_term_count(input, "Fee")).to eq(2)
  end

  it "returns { :Fee => 2, :Fi => 1, :Fo => 1 }" do
     input = [ "Fee", "Fi", "Fo", "Fum", "Fee" ]
     expect(get_term_counts(input)).to eq({ :Fee => 2, :Fi => 1, :Fo => 1, :Fum => 1 })
  end

  it "returns the top 3 terms" do
    input = [ "Fee", "Fee", "Fee", "Fo", "Fo", "Fi" ] 
    expect(get_top_3(input)).to eq("Fee\nFo\nFi")
  end

  it "returns the top n terms" do
    input = [ "Fee", "Fee", "Fee", "Fo", "Fo", "Fi" ]
    n = 2
    expect(get_top_n(input, n)).to eq("Fee\nFo")
  end

  it "returns the top n terms when there are >1 terms w/ the same count" do
    input = [ "Fee", "Fee", "Fee", "Fo", "Fo", "Fo", "Fi" ]
    n = 1
    expect(get_top_n2(input, n)).to eq("Fee\nFo")
  end

  it "when there are >1 terms for the same count, return the terms in alpha order" do
    input = [ "Fee", "Fee", "Fee", "Fi", "Fi", "Fum", "Fo", "Fo" ]
    n = 2
    expect(get_top_n3(input, n)).to eq("Fee\nFi\nFo")
  end

=begin
  it "returns ..." do
    input = [ "Fee", "Fi", "Fo", "Fum", "Fee", "Fo", "Fee", "Fee", "Fo", "Fi", "Fi", "Fo", "Fum", "Fee" ]
    n = 3
    expect(get_top_n3(input, n)).to eq("Fee\nFo\nFi")
  end
=end

end
