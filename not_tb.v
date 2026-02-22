`timescale 1ns/1ps
module tb_NOT;

    reg  [31:0] A;
    wire [31:0] Result;

    NOT dut(A, Result);

    initial begin
        A = 32'h00000000; #10; 
        A = 32'hFFFFFFFF; #10; 
        A = 32'hAAAAAAAA; #10; 
        A = 32'h12345678; #10; 

        $stop;
    end

endmodule