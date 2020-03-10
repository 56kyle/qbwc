module Grammar
  # I spent more time trying to avoid just making a wall of methods then I am proud of. In the end it unfortunately had to be done this way because define_method uses eval.
  def made(a_word)
    self.chain.nil? ? self.chain = [] : nil
    self.chain.push(a_word)
    if block_given?
      words = self.chain.map{|word| word.underscore }.join('_').to_sym
      self.chain = nil
      { words => yield }
    else
      self
    end
  end
  def add; block_given? ? made('add') do yield end : made('add') end
  def del; block_given? ? made('del') do yield end : made('del') end
  def mod; block_given? ? made('mod') do yield end : made('mod') end
  def query; block_given? ? made('query') do yield end : made('query') end
  def void; block_given? ? made('void') do yield end : made('void') end
  def rq; block_given? ? made('rq') do yield end : made('rq') end
  def rs; block_given? ? made('rs') do yield end : made('rs') end
  def ref; block_given? ? made('ref') do yield end : made('ref') end
  def ret; block_given? ? made('ret') do yield end : made('ret') end
  def _group; block_given? ? made('group') do yield end : made('group') end
end

