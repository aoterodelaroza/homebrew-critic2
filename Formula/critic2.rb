class Critic2 < Formula
  desc "Analysis of quantum-chemical and crystallographic data in molecules and solids"
  homepage "https://aoterodelaroza.github.io/critic2/"
  # always build the current master branch; "version" is only a label for
  # brew, so new commits are picked up with "brew reinstall critic2"
  url "https://github.com/aoterodelaroza/critic2.git", branch: "master"
  version "1.4.153"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gcc" # gfortran, libgfortran, libgomp
  depends_on "glfw"
  depends_on "hdf5" # GUI: phonopy hdf5 vibration files
  depends_on "libxc"
  depends_on "nlopt"
  depends_on "openblas"
  depends_on "readline"

  def install
    ENV["FC"] = Formula["gcc"].opt_bin/"gfortran"
    args = %w[
      -DENABLE_GUI=ON
      -DBUILD_TESTING=OFF
      -DUSE_LIBCINT=OFF
      -DUSE_TBLITE=OFF
      -DUSE_XTB=OFF
      -DBLA_VENDOR=OpenBLAS
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"nacl.cri").write <<~EOS
      crystal
       spg f m -3 m
       cell 5.64 5.64 5.64 90 90 90
       neq 0 0 0 na
       neq 1/2 1/2 1/2 cl
      endcrystal
    EOS
    assert_match "Fm-3m (225)", shell_output("#{bin}/critic2 nacl.cri")
    assert_path_exists share/"critic2/shaders/sphere.vs"
  end
end
