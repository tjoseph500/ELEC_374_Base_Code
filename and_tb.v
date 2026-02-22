`timescale 1ns/1ps
module tb_AND;

    reg  [31:0] A_and, B_and;
    wire [31:0] Result_and;

    AND dut(A_and, B_and, Result_and);

    initial begin
        A_and = 32'h00000000; B_and = 32'h00000000; #10;
        A_and = 32'hAAAAAAAA; B_and = 32'h55555555; #10;
        A_and = 32'hFFFFFFFF; B_and = 32'h0F0F0F0F; #10;
        A_and = 32'hDEADBEEF; B_and = 32'hFFFFFFFF; #10;

        $stop;  
    end

endmodule