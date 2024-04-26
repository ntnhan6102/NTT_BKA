`timescale 1ns/1ns
//`include "src/brent_kung_adder_16bit.sv"

module brent_kung_adder_16bit_tb;

    logic [15:0]    A_i, B_i;
    logic           c_i;
    logic [15:0]    S_o;

    brent_kung_adder_16bit dut (
        .A_i(A_i),
        .B_i(B_i),
        .c_i(c_i),
        .S_o(S_o)
    );

    integer i;
    logic [15:0] sum;

    task sum_expect (
        input [15:0]   sum_x
    );

        if (sum_x == S_o) begin
            $display("time = %0t, a_i = 0x%0h, b_i = 0x%0h, c_i = %1b, s_o = 0x%0h => TEST PASS", $time, A_i, B_i, c_i, S_o);
        end else begin
            $display("time = %0t, a_i = 0x%0h, b_i = 0x%0h, c_i = %1b, s_o = 0x%0h => TEST FAIL", $time, A_i, B_i, c_i, S_o);
        end

    endtask

    initial begin
        #0  A_i = 16'b0;
            B_i = 16'b0;
            c_i = 1'b0;

            sum = 16'b0;

        for (i = 0; i < 100; i = i+1) begin
            #10 sum_expect (sum);

            A_i = $random;
            B_i = $random;
            sum = A_i + B_i + c_i;
        end

    end

endmodule
