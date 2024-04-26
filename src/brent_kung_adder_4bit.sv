module brent_kung_adder_4bit (
    input logic     [3:0]   A_i,
    input logic     [3:0]   B_i,
    input logic             c_i,

    output logic    [3:0]   S_o,
    output logic            c_o
);

    logic [3:0] G, P, carry;

    BKA_PreProcessing pre_process (
        .A_i(A_i),
        .B_i(B_i),
        .G_o(G),
        .P_o(P)
    );

    BKA_parallel_prefix_network process (
        .G_i(G),
        .P_i(P),
        .c_o(carry)
    );

    BKA_PostProcessing post_process (
        .P_i(P),
        .c(carry),
        .c_i(c_i),
        .S_o(S_o),
        .c_o(c_o)
    );

endmodule : brent_kung_adder_4bit

module BKA_PreProcessing (
    input logic     [3:0]   A_i, B_i,

    output logic    [3:0]   G_o, P_o
);

    assign G_o = A_i & B_i;
    assign P_o = A_i ^ B_i;

endmodule : BKA_PreProcessing

module BKA_parallel_prefix_network (
    input logic     [3:0]   G_i, P_i,

    output logic    [3:0]   c_o
);

    logic       G1;
    logic       G2;
    logic [1:0] G3, P3;

    assign G1 = G_i[1] | (P_i[1] & G_i[0]);

    assign G2 = G_i[2] | (P_i[2] & G1);

    assign G3[1] = G_i[3] | (P_i[3] & G_i[2]);
    assign P3[1] = P_i[3] & P_i[2];

    assign G3[0] = G3[1] | (P3[1] & G1);

    //carries output
    assign c_o[0] = G_i[0];
    assign c_o[1] = G1;
    assign c_o[2] = G3[0];
    assign c_o[3] = G_i[3] | (P_i[3] & c_o[2]);

endmodule : BKA_parallel_prefix_network

module BKA_PostProcessing (
    input logic     [3:0]   P_i,
    input logic     [3:0]   c,
    input logic             c_i,
 
    output logic    [3:0]   S_o,
    output logic            c_o
);

    //sum ouput
    assign S_o[0] = P_i[0] ^ c_i;
    assign S_o[1] = P_i[1] ^ c[0];
    assign S_o[2] = P_i[2] ^ c[1];
    assign S_o[3] = P_i[3] ^ c[2];

    //carry output
    assign c_o = c[3];

endmodule : BKA_PostProcessing
