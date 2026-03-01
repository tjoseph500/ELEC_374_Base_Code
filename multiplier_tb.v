`timescale 1ns/1ps
module tb_booth_multiplier;

    reg  signed [31:0] M, Q;
    wire signed [63:0] Result;

    booth_multiplier dut(
        .M(M),
        .Q(Q),
        .Result(Result)
    );

    initial begin
        M = 32'sd0;  Q = 32'sd0;  #10;
        M = 32'sd0;  Q = 32'sd25; #10;

        M = 32'sd7;  Q = 32'sd3;  #10;
        M = 32'sd15; Q = 32'sd4;  #10;

        M = 32'sd7;  Q = -32'sd3; #10;

        M = -32'sd5; Q = 32'sd6;  #10;

        M = -32'sd8; Q = -32'sd9; #10;

        M = 32'sh7FFFFFFF; Q = 32'sd2; #10;   // now you'll get 4294967294
        M = 32'sh80000000; Q = 32'sd1; #10;

        $stop;
    end

endmodule