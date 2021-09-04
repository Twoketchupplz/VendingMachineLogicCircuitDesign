library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vending is 
      port( clk, reset                    	        : in std_logic; 
            coin_50, coin_100		   	: in std_logic; 
	    button_coffee, button_tea, button_orange, button_coke    : in std_logic;

        money_dec                                   : out std_logic_vector(6 downto 0); --세그먼트
        sel_decode                                  : out std_logic_vector(7 downto 0); 

        LED_coffee, LED_orange, LED_tea, LED_coke    : out std_logic;  

        give_coffee, give_orange, give_tea, give_coke  : out std_logic;
		lcd_e			: out std_logic;
		lcd_rs			: out std_logic;
		lcd_rw			: out std_logic;
		lcd_data		: out std_logic_vector(7 downto 0);
		piezo			: out std_logic);
--		 rs : out std_logic;
	--    data : out std_logic_vector(7 downto 0);


end vending;

architecture sample of vending is
	constant w0 : std_logic_vector(7 downto 0) := "00110000"; constant w1 : std_logic_vector(7 downto 0) := "00110001";
	constant w2 : std_logic_vector(7 downto 0) := "00110010"; constant w3 : std_logic_vector(7 downto 0) := "00110011";
	constant w4 : std_logic_vector(7 downto 0) := "00110100"; constant w5 : std_logic_vector(7 downto 0) := "00110101";
	constant w6 : std_logic_vector(7 downto 0) := "00110110"; constant w7 : std_logic_vector(7 downto 0) := "00110111";
	constant w8 : std_logic_vector(7 downto 0) := "00111000"; constant w9 : std_logic_vector(7 downto 0) := "00111001";

	constant wA : std_logic_vector(7 downto 0) := "01000001"; constant w_a : std_logic_vector(7 downto 0) := "01100001";
	constant wB : std_logic_vector(7 downto 0) := "01000010"; constant w_b : std_logic_vector(7 downto 0) := "01100010";
	constant wC : std_logic_vector(7 downto 0) := "01000011"; constant w_c : std_logic_vector(7 downto 0) := "01100011";
	constant wD : std_logic_vector(7 downto 0) := "01000100"; constant w_d : std_logic_vector(7 downto 0) := "01100100";
	constant wE : std_logic_vector(7 downto 0) := "01000101"; constant w_e : std_logic_vector(7 downto 0) := "01100101";
	constant wF : std_logic_vector(7 downto 0) := "01000110"; constant w_f : std_logic_vector(7 downto 0) := "01100110";
	constant wG : std_logic_vector(7 downto 0) := "01000111"; constant w_g : std_logic_vector(7 downto 0) := "01100111";
	constant wH : std_logic_vector(7 downto 0) := "01001000"; constant w_h : std_logic_vector(7 downto 0) := "01101000";
	constant wI : std_logic_vector(7 downto 0) := "01001001"; constant w_i : std_logic_vector(7 downto 0) := "01101001";
	constant wJ : std_logic_vector(7 downto 0) := "01001010"; constant w_j : std_logic_vector(7 downto 0) := "01101010";
	constant wK : std_logic_vector(7 downto 0) := "01001011"; constant w_k : std_logic_vector(7 downto 0) := "01101011";
	constant wL : std_logic_vector(7 downto 0) := "01001100"; constant w_l : std_logic_vector(7 downto 0) := "01101100";
	constant wM : std_logic_vector(7 downto 0) := "01001101"; constant w_m : std_logic_vector(7 downto 0) := "01101101";
	constant wN : std_logic_vector(7 downto 0) := "01001110"; constant w_n : std_logic_vector(7 downto 0) := "01101110";
	constant wO : std_logic_vector(7 downto 0) := "01001111"; constant w_o : std_logic_vector(7 downto 0) := "01101111";
	constant wP : std_logic_vector(7 downto 0) := "01010000"; constant w_p : std_logic_vector(7 downto 0) := "01110000";
	constant wQ : std_logic_vector(7 downto 0) := "01010001"; constant w_q : std_logic_vector(7 downto 0) := "01110001";
	constant wR : std_logic_vector(7 downto 0) := "01010010"; constant w_r : std_logic_vector(7 downto 0) := "01110010";
	constant wS : std_logic_vector(7 downto 0) := "01010011"; constant w_s : std_logic_vector(7 downto 0) := "01110011";
	constant wT : std_logic_vector(7 downto 0) := "01010100"; constant w_t : std_logic_vector(7 downto 0) := "01110100";
	constant wU : std_logic_vector(7 downto 0) := "01010101"; constant w_u : std_logic_vector(7 downto 0) := "01110101";
	constant wV : std_logic_vector(7 downto 0) := "01010110"; constant w_v : std_logic_vector(7 downto 0) := "01110110";
	constant wW : std_logic_vector(7 downto 0) := "01010111"; constant w_w : std_logic_vector(7 downto 0) := "01110111";
	constant wX : std_logic_vector(7 downto 0) := "01011000"; constant w_x : std_logic_vector(7 downto 0) := "01111000";
	constant wY : std_logic_vector(7 downto 0) := "01011001"; constant w_y : std_logic_vector(7 downto 0) := "01111001";
	constant wZ : std_logic_vector(7 downto 0) := "01011010"; constant w_z : std_logic_vector(7 downto 0) := "01111010";
	constant wBlank : std_logic_vector(7 downto 0) := "00100000"; constant wColon : std_logic_vector(7 downto 0) := "00111010";
	constant wDot : std_logic_vector(7 downto 0) := "00101110";

	signal s_money : integer range 0 to 30 := 0;
	signal s_50, s_100, s_bcoffee, s_btea, s_borange, s_bcoke : std_logic := '0';
	signal s_segcom : std_logic_vector( 7 downto 0 ) := "11101111";
	signal s_gcoffee, s_gorange, s_gtea, s_gcoke : std_logic := '0';
	signal q1, q2, y1 : std_logic_vector( 5 downto 0 ) := "000000";

	type state is (delay, functions_set, entry_mode, disp_onoff, line1, line2, delay_t, clear_disp);
	signal lcd_state : state;
	signal cnt : integer range 0 to 4095;
	signal MD1, MD2, MD3, MD4, MD5, MD6 : std_logic_vector(7 downto 0) := "00000000";

	signal Counter : integer range 0 to 299 := 0;
	signal s_beep : std_logic := '0';
begin

---------------------Beep start
process( clk )
begin
	if ( clk'event and clk = '1' ) then
		if ( Counter = 0 ) then
			if ( s_beep = '1' ) then
				Counter <= Counter + 1;
			end if;
		elsif ( Counter = 299 ) then
			Counter <= 0;
		elsif ( Counter > 0 ) then
			Counter <= Counter + 1;
		end if;
	end if;
end process;

piezo <= clk when Counter /= 0 else '0';
---------------------Beep end

---------------------LCD start
process( clk )
begin
	if ( clk'event and clk = '1' ) then
		if ( s_gcoffee = '1' ) then
			MD1 <= wC; MD2 <= wO; MD3 <= wF; MD4 <= wF; MD5 <= wE; MD6 <= wE;
		elsif ( s_gorange = '1' ) then
			MD1 <= wO; MD2 <= wR; MD3 <= wA; MD4 <= wN; MD5 <= wG; MD6 <= wE;
		elsif ( s_gtea = '1' ) then
			MD1 <= wT; MD2 <= wE; MD3 <= wA; MD4 <= wBlank; MD5 <= wBlank; MD6 <= wBlank;
		elsif ( s_gcoke = '1' ) then
			MD1 <= wC; MD2 <= wO; MD3 <= wK; MD4 <= wE; MD5 <= wBlank; MD6 <= wBlank;
		else
			MD1 <= wBlank; MD2 <= wBlank; MD3 <= wBlank; MD4 <= wBlank; MD5 <= wBlank; MD6 <= wBlank;
		end if;
	end if;
end process;

process( clk )
begin
	if ( clk'event and clk = '1' ) then
		case lcd_state is
			when delay =>
				if ( cnt = 70 ) then lcd_state <= functions_set; end if;
			when functions_set =>
				if ( cnt = 30 ) then lcd_state <= disp_onoff; end if;
			when disp_onoff =>
				if ( cnt = 30 ) then lcd_state <= entry_mode; end if;
			when entry_mode =>
				if ( cnt = 30 ) then lcd_state <= line1; end if;
			when line1 =>
				if ( cnt = 20 ) then lcd_state <= line2; end if;
			when line2 =>
				if ( cnt = 20 ) then lcd_state <= delay_t; end if;
			when delay_t =>
				if ( cnt = 100 ) then lcd_state <= clear_disp; end if;
			when clear_disp =>
				lcd_state <= line1;
		end case;
	end if;
end process;

process (clk)
begin
	if ( clk'event and clk = '1' ) then
		case lcd_state is
			when delay =>
				if ( cnt = 70 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when functions_set =>
				if ( cnt = 30 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when disp_onoff =>
				if ( cnt = 30 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when entry_mode =>
				if ( cnt = 30 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when line1 =>
				if ( cnt = 20 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when line2 =>
				if ( cnt = 20 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when delay_t =>
				if ( cnt = 100 ) then cnt <= 0;
				else cnt <= cnt + 1; end if;
			when clear_disp =>
				cnt <= 0;
		end case;
	end if;
end process;

process (clk)
begin
	if ( clk'event and clk = '1' ) then
		case lcd_state is
			when delay =>
			when functions_set	=> lcd_rs <= '0'; lcd_rw <= '0'; lcd_data <= "00111100";
			when disp_onoff		=> lcd_rs <= '0'; lcd_rw <= '0'; lcd_data <= "00001100";
			when entry_mode		=> lcd_rs <= '0'; lcd_rw <= '0'; lcd_data <= "00000110";
			when clear_disp		=> lcd_rs <= '0'; lcd_rw <= '0'; lcd_data <= "00000001";
			when delay_t 		=> lcd_rs <= '0'; lcd_rw <= '0'; lcd_data <= "00000010";

	-----------Line-1 출력-------------------
			when line1 =>
				lcd_rw <= '0';
				case cnt is
					when  0 => lcd_rs <= '0'; lcd_data <= "10000000";
					when  1 => lcd_rs <= '1'; lcd_data <= wO;
					when  2 => lcd_rs <= '1'; lcd_data <= wN;
					when  3 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  4 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  5 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  6 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  7 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  8 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  9 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 10 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 11 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 12 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 13 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 14 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 15 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 16 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 17 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 18 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 19 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 20 => lcd_rs <= '1'; lcd_data <= wBlank;
					when others =>
				end case;
	-----------Line-1 출력 끝-----------------

	-----------Line-2 출력--------------------
			when line2 =>
				lcd_rw <= '0';
				case cnt is
					when  0 => lcd_rs <= '0'; lcd_data <= "11000000";
					when  1 => lcd_rs <= '1'; lcd_data <= MD1;
					when  2 => lcd_rs <= '1'; lcd_data <= MD2;
					when  3 => lcd_rs <= '1'; lcd_data <= MD3;
					when  4 => lcd_rs <= '1'; lcd_data <= MD4;
					when  5 => lcd_rs <= '1'; lcd_data <= MD5;
					when  6 => lcd_rs <= '1'; lcd_data <= MD6;
					when  7 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  8 => lcd_rs <= '1'; lcd_data <= wBlank;
					when  9 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 10 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 11 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 12 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 13 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 14 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 15 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 16 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 17 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 18 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 19 => lcd_rs <= '1'; lcd_data <= wBlank;
					when 20 => lcd_rs <= '1'; lcd_data <= wBlank;
					when others =>
				end case;
	----------------Line-2 출력 끝----------------------
		end case;
	end if;
end process;

lcd_e <= clk;
---------------------LCD end

---------------------button start
process ( clk )
	variable btns : std_logic_vector( 5 downto 0 );
begin
	btns := coin_50 & coin_100 & button_coffee & button_tea & button_orange & button_coke;
	if ( clk'event and clk='1' ) then
		q2 <= q1;
		q1 <= btns;
	end if;
end process;

y1 <= q1 and not q2;

process ( clk )
begin
	if ( clk'event and clk='0') then
		s_50 <= y1(5); s_100 <= y1(4);
		s_bcoffee <= y1(3); s_btea <= y1(2); s_borange <= y1(1); s_bcoke <= y1(0);
	end if;
end process;

---------------------button end

---------------------menu select start
process ( clk )
begin
	if ( reset = '1' ) then
		s_money <= 0; s_gcoffee <= '0'; s_gorange <= '0'; s_gtea <= '0'; s_gcoke <= '0';
	elsif ( clk'event and clk = '1' ) then
		if ( Counter = 299 ) then
			s_gcoffee <= '0'; s_gorange <= '0'; s_gtea <= '0'; s_gcoke <= '0'; s_beep <= '0';
		elsif ( s_50 = '1' ) then
			if ( s_money <= 25 ) then
				s_money <= s_money + 5; s_gcoffee <= '0'; s_gorange <= '0'; s_gtea <= '0'; s_gcoke <= '0'; s_beep <= '0';
			end if;
		elsif ( s_100 = '1' ) then
			if ( s_money <= 20 ) then
				s_money <= s_money + 10; s_gcoffee <= '0'; s_gorange <= '0'; s_gtea <= '0'; s_gcoke <= '0'; s_beep <= '0';
			end if;
		elsif ( s_bcoffee = '1' ) then
			if ( s_money >= 10 ) then
				s_money <= s_money - 10; s_gcoffee <= '1'; s_gorange <= '0'; s_gtea <= '0'; s_gcoke <= '0'; s_beep <= '1';
			end if;
		elsif ( s_btea = '1' ) then
			if ( s_money >= 10 ) then
				s_money <= s_money - 10; s_gtea <= '1'; s_gcoffee <= '0'; s_gorange <= '0'; s_gcoke <= '0'; s_beep <= '1';
			end if;
		elsif ( s_borange = '1' ) then
			if ( s_money >= 20 ) then
				s_money <= s_money - 20; s_gorange <= '1'; s_gcoffee <= '0'; s_gtea <= '0'; s_gcoke <= '0'; s_beep <= '1';
			end if;
		elsif ( s_bcoke = '1' ) then
			if ( s_money >= 15 ) then
				s_money <= s_money - 15; s_gcoke <= '1'; s_gcoffee <= '0'; s_gorange <= '0'; s_gtea <= '0'; s_beep <= '1';
			end if;
		end if;
	end if;
end process;
---------------------menu select end

---------------------menu LED start
process ( clk )
begin
	if ( clk'event and clk = '1' ) then
		if ( s_money >= 20 ) then
			LED_coffee <= '1'; LED_orange <= '1'; LED_tea <= '1'; LED_coke <= '1';
		elsif ( s_money >= 15 ) then
			LED_coffee <= '1'; LED_orange <= '0'; LED_tea <= '1'; LED_coke <= '1';
		elsif ( s_money >= 10 ) then
			LED_coffee <= '1'; LED_orange <= '0'; LED_tea <= '1'; LED_coke <= '0';
		else
			LED_coffee <= '0'; LED_orange <= '0'; LED_tea <= '0'; LED_coke <= '0';
		end if;
	end if;
end process;
give_coffee <= s_gcoffee;
give_orange <= s_gorange;
give_tea <= s_gtea;
give_coke <= s_gcoke;
---------------------menu LED end

---------------------segment start
process ( clk )
begin
	if ( clk'event and clk = '1' ) then
		case s_segcom is
			when "11101111" => s_segcom <= "11011111";
			when "11011111" => s_segcom <= "10111111";
			when others => s_segcom <= "11101111";
		end case;
	end if;
end process;

process ( clk )
	variable seg100, seg10 : std_logic_vector( 6 downto 0 ) := "0000000";
	variable iseg10 : integer range 0 to 9 := 0;
begin
	if ( clk'event and clk = '1' ) then
		if ( s_money >= 30 ) then
			seg100 := "1001111"; iseg10 := s_money - 30;
		elsif ( s_money >= 20 ) then
			seg100 := "1011011"; iseg10 := s_money - 20;
		elsif ( s_money >= 10 ) then
			seg100 := "0000110"; iseg10 := s_money - 10;
		else
			seg100 := "0111111"; iseg10 := s_money;
		end if;

		case iseg10 is
			when 0 => seg10 := "0111111"; when others => seg10 := "1101101";
		end case;

		case s_segcom is
			when "11101111" => money_dec <= seg10;
			when "11011111" => money_dec <= seg100;
			when others => money_dec <= "0111111";
		end case;
	end if;
end process;

sel_decode <= s_segcom;
---------------------segment end

end sample;

