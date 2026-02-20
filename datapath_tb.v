`timescale 1ns / 1ps
module datapath_tb();

    reg clock, clear, RZout, RAout, RBout, RAin, RBin, RZin;
    reg [31:0] AddImmediate;
    reg [31:0] RegisterAImmediate;

    reg [3:0] present_state;

    datapath DP(
        clock, clear,
        AddImmediate,          // this connects to datapath input A
        RegisterAImmediate,
        RZout, RAout, RBout,
        RAin, RBin, RZin
    );

    parameter init = 4'd1, T0 = 4'd2, T1 = 4'd3, T2 = 4'd4;

    initial begin
        clock = 0;
        present_state = 4'd0;
    end

    always #10 clock = ~clock;
    always @(negedge clock) present_state = present_state + 1;

    always @(present_state) begin
        case (present_state)

            init: begin
                clear <= 1;
                AddImmediate <= 32'h00000000;
                RegisterAImmediate <= 32'h00000000;
                RZout <= 0; RAout <= 0; RBout <= 0; RAin <= 0; RBin <= 0; RZin <= 0;
                #15 clear <= 0;
            end

            // ldi A, 5
            T0: begin
                RegisterAImmediate <= 32'h00000005;
                RAin <= 1;
                #15 RegisterAImmediate <= 32'h00000000;
                RAin <= 0;
            end

            // addi: Z = RA + immediate(5)
            T1: begin
                RAout <= 1;
                AddImmediate <= 32'h00000005;
                RZin <= 1;
                #15 RAout <= 0;
                RZin <= 0;
            end

            // mv B, Z
            T2: begin
                RZout <= 1;
                RBin <= 1;
                #15 RZout <= 0;
                RBin <= 0;
            end

        endcase
    end

endmodule