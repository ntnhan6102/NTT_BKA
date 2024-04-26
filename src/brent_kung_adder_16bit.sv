module brent_kung_adder_16bit (
    input logic     [15:0]  A_i, B_i,
    input logic             c_i,

    output logic    [15:0]  S_o
);

    logic [15:0]    G, P;
    logic [15:0]    carry;

    BKA_PreProcessing pre_process (
        .A_i(A_i),
        .B_i(B_i),
        .G_o(G),
        .P_o(P)
    );

    BKA_parallel_prefix_network process (
        .G_i(G),
        .P_i(P),
        .carry_o(carry)
    );

    BKA_PostProcessing post_process (
        .P_i(P),
        .carry_i(carry),
        .c_i(c_i),
        .S_o(S_o)
    );

endmodule : brent_kung_adder_16bit

module BKA_PreProcessing (
    input logic     [15:0]  A_i, B_i,

    output logic    [15:0]  G_o, P_o
);

    assign G_o = A_i & B_i;
    assign P_o = A_i ^ B_i;

endmodule : BKA_PreProcessing

module BKA_parallel_prefix_network (
    input logic     [15:0]  G_i, P_i,

    output logic    [15:0]  carry_o
);

    logic [7:0] G1, P1;
    logic [3:0] G2, P2;
    logic [1:0] G3, P3;
    logic       G4;
    logic       G5;
    logic [2:0] G6;
    logic [6:0] G7;

    //stage 1
    assign G1[0] = G_i[1] | (P_i[1] & G_i[0]);      //grey_cell 1:0

    assign G1[1] = G_i[3] | (P_i[3] & G_i[2]);      //black_cell 3:2
    assign P1[1] = P_i[3] & P_i[2];

    assign G1[2] = G_i[5] | (P_i[5] & G_i[4]);      //black_cell 5:4
    assign P1[2] = P_i[5] & P_i[4];

    assign G1[3] = G_i[7] | (P_i[7] & G_i[6]);      //black_cell 7:6
    assign P1[3] = P_i[7] & P_i[6];

    assign G1[4] = G_i[9] | (P_i[9] & G_i[8]);      //black_cell 9:8
    assign P1[4] = P_i[9] & P_i[8];

    assign G1[5] = G_i[11] | (P_i[11] & G_i[10]);   //black_cell 11:10
    assign P1[5] = P_i[11] & P_i[10];

    assign G1[6] = G_i[13] | (P_i[13] & G_i[12]);   //black_cell 13:12
    assign P1[6] = P_i[13] & P_i[12];

    assign G1[7] = G_i[15] | (P_i[15] & G_i[14]);   //black_cell 15:14
    assign P1[7] = P_i[15] & P_i[14];

    //stage 2
    assign G2[0] = G1[1] | (P1[1] & G1[0]);         //grey_cell 3:0

    assign G2[1] = G1[3] | (P1[3] & G1[2]);         //black_cell 7:4
    assign P2[1] = P1[3] & P1[2];

    assign G2[2] = G1[5] | (P1[5] & G1[4]);         //black_cell 11:8
    assign P2[2] = P1[5] & P1[4];

    assign G2[3] = G1[7] | (P1[7] & G1[6]);          //black_cell 15:12
    assign P2[3] = P1[7] & P1[6];

    //stage 3
    assign G3[0] = G2[1] | (P2[1] & G2[0]);         //grey_cell 7:0

    assign G3[1] = G2[3] | (P2[3] & G2[2]);         //black_cell 15:8
    assign P3[1] = P2[3] & P2[2];

    //stage 4
    assign G4 = G3[1] | (P3[1] & G3[0]);            //grey_cell 15:0

    //stage 5
    assign G5 = G2[2] | (P2[2] & G3[0]);            //grey_cell 11:0

    //stage 6
    assign G6[0] = G1[2] | (P1[2] & G2[0]);         //grey_cell 5:0

    assign G6[1] = G1[4] | (P1[4] & G3[0]);         //grey_cell 9:0

    assign G6[2] = G1[6] | (P1[6] & G5);            //grey_cell 13:0

    //stage 7
    assign G7[0] = G_i[2] | (P_i[2] & G1[0]);       //grey_cell 2:0

    assign G7[1] = G_i[4] | (P_i[4] & G2[0]);       //grey_cell 4:0

    assign G7[2] = G_i[6] | (P_i[6] & G6[0]);       //grey_cell 6:0

    assign G7[3] = G_i[8] | (P_i[8] & G3[0]);       //grey_cell 8:0

    assign G7[4] = G_i[10] | (P_i[10] & G6[1]);     //grey_cell 10:0

    assign G7[5] = G_i[12] | (P_i[12] & G5);        //grey_cell 12:0

    assign G7[6] = G_i[14] | (P_i[14] & G6[2]);     //grey_cell 14:0

    //carries output
    assign carry_o[0] = G_i[0];
    assign carry_o[1] = G1[0];
    assign carry_o[2] = G7[0];
    assign carry_o[3] = G2[0];
    assign carry_o[4] = G7[1];
    assign carry_o[5] = G6[0];
    assign carry_o[6] = G7[2];
    assign carry_o[7] = G3[0];
    assign carry_o[8] = G7[3];
    assign carry_o[9] = G6[1];
    assign carry_o[10] = G7[4];
    assign carry_o[11] = G5;
    assign carry_o[12] = G7[5];
    assign carry_o[13] = G6[2];
    assign carry_o[14] = G7[6];
    assign carry_o[15] = G4;

endmodule : BKA_parallel_prefix_network

module BKA_PostProcessing (
    input logic     [15:0]  P_i,
    input logic     [15:0]  carry_i,
    input logic             c_i,

    output logic    [15:0]  S_o
);

    assign S_o[0] = P_i[0] ^ c_i;
    assign S_o[1] = P_i[1] ^ carry_i[0];
    assign S_o[2] = P_i[2] ^ carry_i[1];
    assign S_o[3] = P_i[3] ^ carry_i[2];
    assign S_o[4] = P_i[4] ^ carry_i[3];
    assign S_o[5] = P_i[5] ^ carry_i[4];
    assign S_o[6] = P_i[6] ^ carry_i[5];
    assign S_o[7] = P_i[7] ^ carry_i[6];
    assign S_o[8] = P_i[8] ^ carry_i[7];
    assign S_o[9] = P_i[9] ^ carry_i[8];
    assign S_o[10] = P_i[10] ^ carry_i[9];
    assign S_o[11] = P_i[11] ^ carry_i[10];
    assign S_o[12] = P_i[12] ^ carry_i[11];
    assign S_o[13] = P_i[13] ^ carry_i[12];
    assign S_o[14] = P_i[14] ^ carry_i[13];
    assign S_o[15] = P_i[15] ^ carry_i[14];

endmodule : BKA_PostProcessing
