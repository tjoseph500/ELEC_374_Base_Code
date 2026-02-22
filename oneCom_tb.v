`timescale 1ns/1ps
module oneCom_tb;

    reg  [31:0] A_oneCom;
    wire [31:0] Result_oneCom;

    oneCom DUT (
        .A_oneCom(A_oneCom),
        .Result_oneCom(Result_oneCom)
    );

    initial begin
        // Test 1
        A_oneCom = 32'h00000000;  // Expect FFFFFFFF
        #10;

        // Test 2
        A_oneCom = 32'hFFFFFFFF;  // Expect 00000000
        #10;

        // Test 3
        A_oneCom = 32'hAAAAAAAA;  // Expect 55555555
        #10;

        // Test 4
        A_oneCom = 32'h12345678;
        #10;

        $stop;
    end

endmodule