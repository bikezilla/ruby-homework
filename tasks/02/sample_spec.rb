describe TodoList do
  let(:text_input) do
    <<-END
      TODO    | Eat spaghetti.               | High   | food, happiness
      TODO    | Get 8 hours of sleep.        | Low    | health
      CURRENT | Party animal.                | Normal | socialization
      CURRENT | Grok Ruby.                   | High   | development, ruby
      DONE    | Have some tea.               | Normal |
      TODO    | Destroy Facebook and Google. | High   | save humanity, conspiracy
      TODO    | Hunt saber-toothed cats.     | Low    | wtf
      DONE    | Do the 5th Ruby challenge.   | High   | ruby course, FMI, development, ruby
      TODO    | Find missing socks.          | Low    |
      CURRENT | Grow epic mustache.          | High   | sex appeal
    END
  end

  let(:todo_list) { TodoList.parse text_input }

  it 'should return an array of tasks' do
    todo_list.class.should eq TodoList
  end

  it 'filters tasks by status' do
    todo_list.filter(Criteria.status(:todo)).map(&:status).uniq.should =~ [:todo]
  end

  it "filters tasks by tag" do
    todo_list.filter(Criteria.tags %w[wtf]).map(&:description).should =~ ['Hunt saber-toothed cats.']
  end

  it "filters tasks by tag 2" do
    todo_list.filter(Criteria.tags %w[development]).map(&:description).should =~ ['Grok Ruby.', 'Do the 5th Ruby challenge.']
  end

  it "filters tasks by tag 3" do
    todo_list.filter(Criteria.tags ['ruby course']).map(&:description).should =~ ['Do the 5th Ruby challenge.']
  end

  it "filters tasks by tag 4" do
    filtered = todo_list.filter Criteria.tags(%w[development ruby])
    filtered.map(&:description).should =~ ['Grok Ruby.', 'Do the 5th Ruby challenge.']
  end

  it "filters tasks by tag 5" do
    filtered = todo_list.filter Criteria.tags(%w[development FMI])
    filtered.map(&:description).should =~ ['Do the 5th Ruby challenge.']
  end

  it "supports a conjuction of filters" do
    filtered = todo_list.filter Criteria.status(:todo) & Criteria.priority(:high)
    filtered.map(&:description).should =~ ['Eat spaghetti.', 'Destroy Facebook and Google.']
  end

  it "supports a disjunction of filters" do
    filtered = todo_list.filter Criteria.tags(['development']) | Criteria.priority(:low)
    filtered.map(&:description).should =~ ['Grok Ruby.', 'Do the 5th Ruby challenge.', 'Get 8 hours of sleep.', 'Hunt saber-toothed cats.', 'Find missing socks.']
  end

  it "supports a negation of filters" do
    filtered = todo_list.filter Criteria.priority(:high) & !Criteria.tags(['food'])
    filtered.map(&:description).should =~ ['Grok Ruby.', 'Destroy Facebook and Google.', 'Do the 5th Ruby challenge.', 'Grow epic mustache.']
  end

  it "can be adjoined with another to-do list" do
    development = todo_list.filter Criteria.tags(['development'])
    food        = todo_list.filter Criteria.tags(['food'])
    adjoined    = development.adjoin food

    adjoined.count.should eq 3
    adjoined.map(&:description).should =~ [
                                           'Eat spaghetti.',
                                           'Grok Ruby.',
                                           'Do the 5th Ruby challenge.'
                                          ]
  end

  it "can be adjoined with another or conjucted" do
    filtered = todo_list.filter Criteria.tags(['development']) | Criteria.priority(:low)
    adjoined = todo_list.filter(Criteria.tags(['development'])).adjoin(todo_list.filter(Criteria.priority(:low)))

    filtered.map(&:description).should =~ adjoined.map(&:description)
  end


  it "filters tasks by multiple tags" do
    todo_list.filter(Criteria.tags %w[development ruby]).map(&:description).should =~ [
                                                                                       'Grok Ruby.',
                                                                                       'Do the 5th Ruby challenge.'
                                                                                      ]
  end

  it "filtering by multiple tags matches only tasks with all the tags" do
    todo_list.filter(Criteria.tags %w[development FMI]).map(&:description).should =~ ['Do the 5th Ruby challenge.']
  end

  it "returns the number of the completed tasks" do
    todo_list.tasks_completed.should eq 2
  end
end
