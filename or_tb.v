`timescale 1ns/1ps
module tb_OR;

    reg  [31:0] A_or, B_or;
    wire [31:0] Result_or;

    OR dut(A_or, B_or, Result_or);

    initial begin
        A_or = 32'h00000000; B_or = 32'h00000000; #10; 
        A_or = 32'hAAAAAAAA; B_or = 32'h55555555; #10; 
        A_or = 32'hFFFFFFFF; B_or = 32'h0F0F0F0F; #10; 
        A_or = 32'hDEADBEEF; B_or = 32'h00000000; #10; 
        $stop;
    end

endmodule