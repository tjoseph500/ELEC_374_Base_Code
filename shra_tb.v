`timescale 1ns/1ps
module tb_shra;

    reg  [31:0] A;
    reg  [4:0] shiftamount;
    wire [31:0] Result;

    shra dut(A, shiftamount, Result);

    initial begin
        // Test 1: Positive number shift by 1 (8 >> 1 = 4)
        A = 32'h00000008; shiftamount = 5'd1; #10;
        
        // Test 2: Positive number shift by 4 (128 >> 4 = 8)
        A = 32'h00000080; shiftamount = 5'd4; #10;
        
        // Test 3: Negative number shift by 1 (-8 >> 1 = -4)
        A = 32'hFFFFFFF8; shiftamount = 5'd1; #10;
        
        // Test 4: Negative number shift by 4 (-128 >> 4 = -8)
        A = 32'hFFFFFF80; shiftamount = 5'd4; #10;
        
        // Test 5: Negative number shift by 8
        A = 32'hF0000000; shiftamount = 5'd8; #10;
        
        // Test 6: Shift by 0 (no change)
        A = 32'h00000008; shiftamount = 5'd0; #10;
        
        // Test 7: All ones ( -1 >> any = -1)
        A = 32'hFFFFFFFF; shiftamount = 5'd3; #10;
        
        $stop;
    end

endmodule
