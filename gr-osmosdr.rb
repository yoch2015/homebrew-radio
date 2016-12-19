require 'formula'

class GrOsmosdr < Formula
  homepage 'http://sdr.osmocom.org/trac/wiki/GrOsmoSDR'
  head 'https://github.com/osmocom/gr-osmosdr.git'

  depends_on 'cmake' => :build
  depends_on 'gnuradio'
  depends_on 'rtlsdr' => [:optional, 'with-rtlsdr']

  option 'with-fcd', 'Build with fcd support'

  def install
    mkdir 'build' do
      args = std_cmake_args
      args << "-DENABLE_FCD=OFF" if build.without? 'fcd'
      args << "-DPYTHON_LIBRARY=#{python_path}/Frameworks/Python.framework/"
      system 'cmake', '..', *args
      system 'make'
      system 'make install'
    end
  end

  def python_path
    python = Formula.factory('python')
    kegs = python.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end
end