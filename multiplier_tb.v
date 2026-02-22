`timescale 1ns/1ps
module tb_booth_multiplier;

    reg  signed [31:0] M, Q;
    wire signed [31:0] Result;

    booth_multiplier dut(M, Q, Result);

    initial begin
        // 0 cases
        M = 32'sd0;  Q = 32'sd0;  #10;
        M = 32'sd0;  Q = 32'sd25; #10;

        // positive × positive
        M = 32'sd7;  Q = 32'sd3;  #10;
        M = 32'sd15; Q = 32'sd4;  #10;

        // positive × negative
        M = 32'sd7;  Q = -32'sd3; #10;

        // negative × positive
        M = -32'sd5; Q = 32'sd6;  #10;

        // negative × negative
        M = -32'sd8; Q = -32'sd9; #10;

        // edge cases
        M = 32'sh7FFFFFFF; Q = 32'sd2; #10;
        M = 32'sh80000000; Q = 32'sd1; #10;

        $stop;
    end

endmodule