library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity fetch is
	generic(
		nbits	: positive	:= 32
	);
	port(
		PCBranchD	: in std_logic_vector(nbits-1 downto 0);
		PCJump28	: in std_logic_vector(nbits-5 downto 0);
		PCSrcD		: in std_logic;
		clk			: in std_logic;		
		reset		: in std_logic;
		Instruction	: in std_logic_vector(nbits-1 downto 0);
		PCF			: out std_logic_vector(nbits-1 downto 0);
		PCPlus4F	: out std_logic_vector(nbits-1 downto 0);
		InstrD	    : out std_logic_vector(nbits-1 downto 0)
	);
end fetch;	
	
architecture fetch_arc of fetch is
	signal PCPlus4	: std_logic_vector(nbits-1 downto 0);
	signal PClinha	: std_logic_vector(nbits-1 downto 0);
	signal PCNormal	: std_logic_vector(nbits-1 downto 0);
	signal PCJump	: std_logic_vector(nbits-1 downto 0);
	
	component mux2
		port(
			d0, d1	: in STD_LOGIC_VECTOR(nbits downto 0);
			s		: in STD_LOGIC;
			y		: out STD_LOGIC_VECTOR(nbits downto 0)
		);
	end component;
	
begin
	
	-- calculando PC + 4
    -- TODO: Alhao: Isso aqui ta errado, PCF eh saida!!
    -- TODO: Alhao: e na linha debaixo tem que usar variable, com signal nao da certo issoae.
	PCPlus4F <= PCF + 4;
	PCPlus4 <= PCPlus4F;
	
	pcnorm	: mux2 port map (PCPlus4, PCBranchD, PCSrcD, PCNormal);
	
	PCJump <= PCPlus4(nbits-1 downto nbits-5) & PCJump28;

	-- Workaround para receber o InstrD diretamente da entrada do MIPS
	InstrD <= Instruction;
	
	pc		: mux2 port map (PCNormal, PCJump, Jump, PCLinha);
	
	
	process(clk) begin
	
		if(reset = '1') then
			PCLinha <= "0H"; 									-- TODO: não sei como passar esse valor!!!!
		end if;
	
		-- Rising Edge of the clock
		if(clk'event and clk = '1') then
		
			PCF <= PClinha;
	
		end if;	
	
	end process;

end;
