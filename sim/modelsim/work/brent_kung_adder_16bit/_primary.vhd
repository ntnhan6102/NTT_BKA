library verilog;
use verilog.vl_types.all;
entity brent_kung_adder_16bit is
    port(
        A_i             : in     vl_logic_vector(15 downto 0);
        B_i             : in     vl_logic_vector(15 downto 0);
        c_i             : in     vl_logic;
        S_o             : out    vl_logic_vector(15 downto 0)
    );
end brent_kung_adder_16bit;
