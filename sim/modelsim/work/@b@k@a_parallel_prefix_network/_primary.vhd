library verilog;
use verilog.vl_types.all;
entity BKA_parallel_prefix_network is
    port(
        G_i             : in     vl_logic_vector(15 downto 0);
        P_i             : in     vl_logic_vector(15 downto 0);
        carry_o         : out    vl_logic_vector(15 downto 0)
    );
end BKA_parallel_prefix_network;
