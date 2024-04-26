library verilog;
use verilog.vl_types.all;
entity BKA_PostProcessing is
    port(
        P_i             : in     vl_logic_vector(15 downto 0);
        carry_i         : in     vl_logic_vector(15 downto 0);
        c_i             : in     vl_logic;
        S_o             : out    vl_logic_vector(15 downto 0)
    );
end BKA_PostProcessing;
