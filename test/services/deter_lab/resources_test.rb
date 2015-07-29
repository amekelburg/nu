require 'services/deter_lab/abstract_test'

class DeterLab::ResourcesTest < DeterLab::AbstractTest

  test 'viewing' do
    VCR.use_cassette 'deterlab/resources/view-resources' do
      login 'aadams'

      res = DeterLab.view_resources('aadams', realization: 'Alfa-Romeo:ExperimentOne-aadams:aadams', persist: false)
      rd = res.first
      assert_nil rd.description
      assert_equal [], rd.facets
      assert_equal "admin:Alfa-Romeo!ExperimentOne-aadams!aadams!a", rd.name
      assert_equal [ "MODIFY_RESOURCE", "MODIFY_RESOURCE_ACCESS" ], rd.perms
      assert_equal [], rd.tags
      assert_equal "Qemu VM", rd.type

      rd = res.last
      assert_equal [ ["peer", "admin:hpc118-0-1"], ["port", "35"], ["host", "admin:HPS10c1-1-35"], ["hostname", "admin:HPS10c1"], ["card", "1"], ["peername", "admin:hpc118"]], rd.tags.map { |t| [ t.name, t.value ] }
    end
  end

end
