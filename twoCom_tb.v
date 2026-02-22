`timescale 1ns/1ps
module twoCom_tb;

    reg  [31:0] A_twoCom;
    wire [31:0] Result_twoCom;

    // Instantiate DUT
    twoCom DUT (
        .A_twoCom(A_twoCom),
        .Result_twoCom(Result_twoCom)
    );

    initial begin
        // Test 1: 0 -> 0
        A_twoCom = 32'h00000000;  
        #10;

        // Test 2: 1 -> FFFFFFFF (-1)
        A_twoCom = 32'h00000001;  
        #10;

        // Test 3: 2 -> FFFFFFFE (-2)
        A_twoCom = 32'h00000002;  
        #10;

        // Test 4: AAAAAAAA -> 55555556
        A_twoCom = 32'hAAAAAAAA;  
        #10;

        // Test 5: 80000000 (edge case)
        A_twoCom = 32'h80000000;  
        #10;

        $stop;
    end

endmodule