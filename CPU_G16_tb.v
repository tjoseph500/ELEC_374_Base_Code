// and data fix formatting only
// path_tb.v file: <This is the filename>

`timescale 1ns/10ps

module CPU_G16_tb;

    reg PCout, Zlowout, MDRout, R7out, R0out, R4out;
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read, SHR, R7in, R0in, R4in;
    reg Clock, stateClock;
	 reg clear;
    reg [31:0] Mdatain;

    parameter Default     = 4'b0000,
              Reg_load1a  = 4'b0001,
              Reg_load1b  = 4'b0010,
              Reg_load2a  = 4'b0011,
              Reg_load2b  = 4'b0100,
              Reg_load3a  = 4'b0101,
              Reg_load3b  = 4'b0110,
              T0          = 4'b0111,
              T1          = 4'b1000,
              T2          = 4'b1001,
              T3          = 4'b1010,
              T4          = 4'b1011,
              T5          = 4'b1100;

    reg [3:0] Present_state = Default;

 CPU_G16 DUT(Clock, clear, Read, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, HIin, LOin, Zin, Zhighin, Zlowin, PCin, MDRin, InPortin, Cin, Yin, IRin, ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, AND, OR, NEG, NOT, Mdatain);

    // Clock generation
    initial begin
        Clock = 0;
        forever #1 Clock = ~Clock;
    end
	 
	 initial begin
        stateClock = 0;
        forever #50 stateClock = ~stateClock;
    end

    // FSM state transitions
    always @(posedge stateClock) begin
        case (Present_state)
            Default     : Present_state = Reg_load1a;
            Reg_load1a  : Present_state = Reg_load1b;
            Reg_load1b  : Present_state = Reg_load2a;
            Reg_load2a  : Present_state = Reg_load2b;
            Reg_load2b  : Present_state = Reg_load3a;
            Reg_load3a  : Present_state = Reg_load3b;
            Reg_load3b  : Present_state = T0;
            T0          : Present_state = T1;
            T1          : Present_state = T2;
            T2          : Present_state = T3;
            T3          : Present_state = T4;
            T4          : Present_state = T5;
        endcase
    end

    // Control signal assignments per state
    always @(Present_state) begin
        case (Present_state)

            Default: begin
                PCout <= 0; Zlowout <= 0; MDRout <= 0;
                MARin <= 0; Zin <= 0;
                PCin  <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
                IncPC <= 0; Read  <= 0; SHR  <= 0;
                R7in  <= 0; R0in  <= 0; R4in <= 0;
					 clear <= 0;
                Mdatain <= 32'h00000000;
            end

            Reg_load1a: begin
                Mdatain <= 32'h00000034;
                Read = 0; MDRin = 0;
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end

            Reg_load1b: begin
                MDRout <= 1; R0in <= 1;
                #15 MDRout <= 0; R0in <= 0;
            end

            Reg_load2a: begin
                Mdatain <= 32'h00000045;
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end

            Reg_load2b: begin
                MDRout <= 1; R4in <= 1;
                #15 MDRout <= 0; R4in <= 0;
            end

            Reg_load3a: begin
                Mdatain <= 32'h00000067;
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end

            Reg_load3b: begin
                MDRout <= 1; R0in <= 1;
                #15 MDRout <= 0; R0in <= 0;
            end

            T0: begin
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
					 #15 PCout <= 0; IncPC <= 0; MARin<=0; Zin<=0;
            end

            T1: begin
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
                Mdatain <= 32'h112B0000;  // opcode for "and R2, R5, R6"
					 #15 Zlowout <= 0;
            end

            T2: begin
                MDRout <= 1; IRin <= 1;
					 #15 MDRout <= 0; IRin <= 0;

            end

            T3: begin
                R0out <= 1; Yin <= 1;
					 #15 R0out <= 0; Yin <= 0;
            end

            T4: begin
                R4out <= 1; SHR <= 1; Zin <= 1;
					 #15 R4out <= 0; Zin <= 0;
            end

            T5: begin
                Zlowout <= 1; R7in <= 1;
            end

        endcase
    end

endmodule