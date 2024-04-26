library verilog;
use verilog.vl_types.all;
entity brent_kung_adder_4bit is
    port(
        A_i             : in     vl_logic_vector(3 downto 0);
        B_i             : in     vl_logic_vector(3 downto 0);
        c_i             : in     vl_logic;
        S_o             : out    vl_logic_vector(3 downto 0);
        c_o             : out    vl_logic
    );
end brent_kung_adder_4bit;
