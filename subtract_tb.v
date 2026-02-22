`timescale 1ns/1ps
module subtract_tb;

    reg  [31:0] A_sub, B_sub;
    wire [31:0] Result_sub;

    subtract DUT (
        .A_sub(A_sub),
        .B_sub(B_sub),
        .Result_sub(Result_sub)
    );

    initial begin
        // 10 - 3 = 7
        A_sub = 32'd10; B_sub = 32'd3;  #10;

        // 3 - 10 = -7 (two's complement)
        A_sub = 32'd3;  B_sub = 32'd10; #10;

        // 0 - 1 = -1
        A_sub = 32'd0;  B_sub = 32'd1;  #10;

        // 0x80000000 - 1 = 0x7FFFFFFF (wrap)
        A_sub = 32'h80000000; B_sub = 32'd1; #10;

        $stop;
    end
endmodule