require 'services/deter_lab/abstract_test'

class DeterLab::RealizationsTest < DeterLab::AbstractTest

  test 'viewing no realizations' do
    VCR.use_cassette 'deterlab/realizations/view-realizations-empty' do
      login 'john'
      res = DeterLab.view_realizations('john')
      assert_equal [], res
    end
  end

  test 'realizing experiment missing' do
    VCR.use_cassette 'deterlab/realizations/realize-experiment-missing' do
      login 'john'

      ex = assert_raises(DeterLab::RequestError) { DeterLab.realize_experiment('john', 'john:experiment', 'john:circle') }
      assert_equal "No such experiment: john:experiment", ex.message
    end
  end

  test 'realizing existing experiment' do
    # VCR.use_cassette 'deterlab/realizations/realize-experiment-existing', record: :all do
    #   login 'aadams'

    #   res = DeterLab.realize_experiment('aadams', 'Alfa-Romeo:ExperimentOne', 'Alfa-Romeo:Alfa-Romeo')
    #   assert_nil res
    # end
    skip
  end

  test 'releasing resources' do
    skip
  end

  test 'removing realization' do
    skip
  end

end
