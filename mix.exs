defmodule Mix.Tasks.Compile.Udhcpc do
  @shortdoc "Compiles the port binary"
  def run(_) do
    {result, _error_code} = System.cmd("make", ["priv/udhcpc_wrapper"], stderr_to_stdout: true)
    IO.binwrite result
    Mix.Project.build_structure
  end
end

defmodule Nerves.InterimWiFi.Mixfile do
  use Mix.Project

  def project do
    [app: :nerves_interim_wifi,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: Mix.compilers ++ [:Udhcpc],
     deps: deps,
     docs: [extras: ["README.md"]],
     package: package,
     description: description
	]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :net_basic, :wpa_supplicant],
     mod: {Nerves.InterimWiFi, []}]
  end

  defp description do
    """
    Test of IP network configuration.
    """
  end

  defp package do
    %{files: ["lib", "src/*.[ch]", "test", "mix.exs", "README.md", "LICENSE", "Makefile"],
      maintainers: ["Frank Hunleth"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/fhunleth/nerves_interim_wifi.ex"}}
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:net_basic, github: "fhunleth/net_basic.ex", tag: "master"},
      {:wpa_supplicant, "~> 0.2.0"}
    ]
  end
end
