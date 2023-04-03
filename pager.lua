#!/usr/bin/lua

--[[
	pages.lua: calculates page numbers for printing books. Written because I got sick of doing it by hand. Ver. 1.3.
	
	Designed for use with Canon LBP6030 model printer or any other that employs the same way of printing: pages are
	output face-down. Use as follows: copy and paste the row of numbers labelled "Side 1", print, take the output
	pages AS IS back to the input, copy and paste the row labelled "Side 2", print. The resulting signature is already
	sorted. The book must have at least 4 empty pages in the end (required by technology).
	
	Changelog:
	- ver. 1.0: replicates the way I was doing it originally, through a table of page numbers
	- ver. 1.1: simplifies the process by reshuffling the pages in side 2
	- ver. 1.2: removes an auxiliary array through some number manipulations; improved documentation
    - ver. 1.3: organizes the actions into functions and adds interactive parameter acquisition
--]]

--[[ **Function for interactive parameter acquisition** ]]--

local function ask()
    io.write "Please, enter the number of pages in the book: "
    local pages = io.read("n")

    io.write "Please, enter the desired number of pages in a signature: "
    local sig_size = io.read("n")

    io.write "\n"

    return pages, sig_size
end

--[[ **Checking for input correctness** ]]--

local function check_inputs(size, sigs)
--[[
  It isn't optimal to make books with signatures of less than 12 or greater than 20 pages, so here we
  consider any number, other than 12, 16 or 20 to be invalid input. Furthermore, the number of pages
  should be divisible by signature size. Otherwise, there will be signatures of different sizes
--]]

    if size ~= 12 and size ~= 16 and size ~= 20 then
        io.stderr:write "Incorrect input data: signature size must be either 12, 16 or 20\n"
        os.exit(false)
    end

    if sigs % 1 ~= 0 then
        io.stderr:write "Incorrect input data: number of pages isn't divisible by signature size\n"
        os.exit(false)
    end
end

--[[ **Building the array of numbers** ]]--

local function calculate_pages(pages, size, sigs)
    -- Defining an auxiliary variable (to simplify formulas) and the array with signatures
    local s, signatures = size // 2, {}

    -- Building the array. For information about the algorithm, see below
    for i = 1, sigs do
        signatures[i] = {{}, {}}
        for j = 1, s do
            signatures[i][1][j] = math.tointeger((size * (i - 1) + s + (-1)^j * (j - s - 1) - 2) % pages)
            signatures[i][2][j] = math.tointeger((size * (i - 1) + s + (-1)^j * (j - 1) - 3) % pages + 1)
        end
    end

    return signatures

--[[
	The procedure: through a little bit of meddling with Wolfram Mathematica, I found that there are two formulas,
	which give me the sequences of numbers for sides 1 and 2 respectively (actually, three, if you want to use the
	unshuffled side 2. This way it's easier to correspond number to actual sheets of paper but slightly less
	convenient when printing). They are:
	
	side 1: S/2 + (-1)^n * (n - S/2 - 1),
	side 2: S/2 + (-1)^n * (n - 1),
	
	where S is the signature size and n is the number of the element in the sequence. These two formulas
	result in numbers [1 .. S] shuffled as needed. So then I introduced a variable s = S/2 and added the
	part S * (m - 1), where m is the number of the signature I want the sequence for. Which results in:
	
	side 1: S * (m - 1) + s + (-1)^n * (n - s - 1),
	side 2: S * (m - 1) + s + (-1)^n * (n - 1).
	
	Originally, I used these formulas to pick numbers from a pre-constructed array of page numbers [1 .. N],
	cyclically rotated by 2. Unfortunately, that required the pre-constructed array. So then I used the fact
	that the use of rotated array results in numbers, smaller by 2, compared to the formulas as is. So I did
	that in the formulas and added mod division by page number:
	
	side 1: (S * (m - 1) + s + (-1)^n * (n - s - 1) - 2) mod N,
	side 2: (S * (m - 1) + s + (-1)^n * (n - 1) - 2) mod N.
	
	That resulted in a zero in side 2 where N must be. So I did a little hack:
	
	side 2: 1 + (S * (m - 1) + s + (-1)^n * (n - 1) - 3) mod N.
	
	That gives me the formulas to build the desired array without any auxiliary variables.
--]]
end

--[[ **Output** ]]--

local function print_signatures(signatures)
    local n_sig = #signatures

    io.write("Total number of signatures is ", n_sig, ".\n\n")

    for i, sig in ipairs(signatures) do
        io.write("Signature ", i, ":\n")
        io.write("Side 1: ", tostring(table.concat(sig[1], ", ")), "\n")
        io.write("Side 2: ", tostring(table.concat(sig[2], ", ")), "\n\n")
    end
end

--[[ **Extracting initial data from CLI parameters and calculating number of signatures** ]]--

local n_pages, sig_size, n_sig

-- Obtaining the number of pages and signature size from arguments or interactive input
if #arg >= 2 then
    n_pages, sig_size = math.tointeger(arg[1]), math.tointeger(arg[2])
else
    n_pages, sig_size = ask()
end

-- Computing the number of signatures
n_sig = n_pages / sig_size

check_inputs(sig_size, n_sig)
print_signatures(calculate_pages(n_pages, sig_size, n_sig))
