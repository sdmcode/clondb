describe 'database' do

  def run_script(commands)
    raw_output = nil
    IO.popen("./build/clon.exe", "r+") do |pipe|
      commands.each do |command|
        begin
          pipe.puts command
        rescue Errno::EPIPE
          break
        end
      end

      pipe.close_write

      raw_output = pipe.gets(nil)
    end
    raw_output.split("\n")
  end

  it 'prints error message when table is full' do
    script = (1..17).map do |i|
      "insert #{i} user#{i} person#{i}@example.com"
    end

    script << ".exit"
    result = run_script(script)
    expect(result[-2]).to eq('clon > Error: Table full')
  end

  it 'inserts and retrieves a row' do
    result = run_script([
      "insert 1 user1 person1@example.com",
      "select",
      ".exit",
      ])
      expect(result).to match_array([
          "Initialising..",
          "clon > Executed",
          "clon > (1, user1, person1@example.com)",
          "Executed",
          "clon > ",
        ])
  end

  it 'allows inserting strings that are the maximum length' do
    long_username = "a" * 31
    long_email = "a" * 255

    script = [
      "insert 1 #{long_username} #{long_email}",
      "select",
      ".exit"
    ]

    result = run_script(script)
    expect(result).to match_array([
        "Initialising..",
        "clon > Executed",
        "clon > (1, #{long_username}, #{long_email})",
        "Executed",
        "clon > ",
      ])
  end

end
