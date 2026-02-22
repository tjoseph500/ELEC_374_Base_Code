`timescale 1ns/1ps
module tb_divider;

    reg  [31:0] M;   // Divisor
    reg  [31:0] Q;   // Dividend
    wire [63:0] Result;

    divider dut(M, Q, Result);

    initial begin

        // 10 / 2 = 5 remainder 0
        Q = 32'd10;  M = 32'd2;   #10;

        // 15 / 4 = 3 remainder 3
        Q = 32'd15;  M = 32'd4;   #10;

        // 100 / 3 = 33 remainder 1
        Q = 32'd100; M = 32'd3;   #10;

        // 7 / 7 = 1 remainder 0
        Q = 32'd7;   M = 32'd7;   #10;

        // 5 / 10 = 0 remainder 5
        Q = 32'd5;   M = 32'd10;  #10;

        // large values
        Q = 32'd100000; M = 32'd100; #10;

        // divide by zero case
        Q = 32'd50;  M = 32'd0;   #10;

        $stop;
    end

endmodule