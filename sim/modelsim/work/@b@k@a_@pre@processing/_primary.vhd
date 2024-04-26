library verilog;
use verilog.vl_types.all;
entity BKA_PreProcessing is
    port(
        A_i             : in     vl_logic_vector(15 downto 0);
        B_i             : in     vl_logic_vector(15 downto 0);
        G_o             : out    vl_logic_vector(15 downto 0);
        P_o             : out    vl_logic_vector(15 downto 0)
    );
end BKA_PreProcessing;
