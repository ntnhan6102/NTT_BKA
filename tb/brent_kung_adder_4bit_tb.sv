`timescale 1ns/1ns
`include "src/brent_kung_adder_4bit.sv"

module brent_kung_adder_4bit_tb;

    logic [3:0] A_i, B_i;
    logic       c_i;
    logic [3:0] S_o;
    logic       c_o;

    brent_kung_adder_4bit dut (
        .A_i(A_i),
        .B_i(B_i),
        .c_i(c_i),
        .S_o(S_o),
        .c_o(c_o)
    );

    integer i;
    logic [4:0] sum;


    task sum_expect (
        input [3:0]   sum_x,
        input         c_x
    );

        if ((sum_x == S_o) & (c_x == c_o)) begin
            $display("time = %0t, a_i = 0x%0h, b_i = 0x%0h, c_i = %1b, s_o = 0x%0h, c_o = %1b => TEST PASS", $time, A_i, B_i, c_i, S_o, c_o);
        end else begin
            $display("time = %0t, a_i = 0x%0h, b_i = 0x%0h, c_i = %1b, s_o = 0x%0h, c_o = %1b => TEST FAIL", $time, A_i, B_i, c_i, S_o, c_o);
        end

    endtask

    initial begin
        #0  A_i = 4'b0;
            B_i = 4'b0;
            c_i = 1'b0;

            sum = 5'b0;

        for (i = 0; i < 100; i = i+1) begin
            #10 sum_expect (sum[3:0], sum[4]);

            A_i = $random;
            B_i = $random;
            sum = A_i + B_i + c_i;
        end

    end

endmodule
