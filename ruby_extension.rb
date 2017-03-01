class NilClass
  def blank?
    true
  end

  def present?
    !blank?
  end
end

class String
  def space_split
    self.strip.split(/\s+/)
  end
  
  def blank?
    self.strip.empty?
  end

  def present?
    !blank?
  end
end

class Array
  alias_method :add, :push
end