source spec/helpers.vim

describe 'Running'

  after
    call Teardown()
  end

  it "runs tests on different granularities"
    edit foo_spec.rb

    TestNearest
    Expect LastCommand() == 'rspec foo_spec.rb:1'

    TestFile
    Expect LastCommand() == 'rspec foo_spec.rb'

    TestSuite
    Expect LastCommand() == 'rspec'
  end

  it "remembers the last test-run position"
    edit foo_spec.rb
    TestFile

    edit foo.txt
    TestFile

    Expect LastCommand() == 'rspec foo_spec.rb'
  end

  it "runs last test"
    edit foo_spec.rb
    TestNearest

    edit bar_spec.rb
    TestLast

    Expect LastCommand() == 'rspec foo_spec.rb:1'
  end

  it "doesn't raise an error when unable to run tests"
    edit foo.txt
    TestNearest | TestFile | TestSuite | TestLast
  end

  it "picks a user defined test#{runner}#executable"
    let g:test#ruby#rspec#executable = 'foo'

    edit foo_spec.rb
    TestFile

    Expect LastCommand() == 'foo foo_spec.rb'

    unlet g:test#ruby#rspec#executable
  end

end
