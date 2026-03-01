`timescale 1ns/10ps
module datapath_add_tb;

  reg PCout, Zlowout, Zhighout, MDRout, R5out, R6out;
  reg MARin, Zin, PCin, MDRin, IRin, Yin;
  reg IncPC, Read;
  reg ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, AND, OR, NEG, NOT;
  reg R2in, R5in, R6in;
  reg Clock;
  reg [31:0] Mdatain;

  parameter Default=4'b0000,
            Reg_load1a=4'b0001, Reg_load1b=4'b0010,
            Reg_load2a=4'b0011, Reg_load2b=4'b0100,
            T0=4'b0101, T1=4'b0110, T2=4'b0111,
            T3=4'b1000, T4=4'b1001, T5=4'b1010;

  reg [3:0] Present_state = Default;

  datapath DUT(
    .clock(Clock), .clear(1'b0),
    .MARin(MARin), .IRin(IRin), .IncPC(IncPC), .Read(Read), .Mdatain(Mdatain),

    .PCout(PCout), .Zlowout(Zlowout), .Zhighout(Zhighout), .MDRout(MDRout),
    .R5out(R5out), .R6out(R6out),

    .R0out(1'b0), .R1out(1'b0), .R2out(1'b0), .R3out(1'b0), .R4out(1'b0),
    .R7out(1'b0), .R8out(1'b0), .R9out(1'b0), .R10out(1'b0), .R11out(1'b0),
    .R12out(1'b0), .R13out(1'b0), .R14out(1'b0), .R15out(1'b0),
    .HIout(1'b0), .LOout(1'b0), .InPortout(1'b0), .Cout(1'b0),

    .R2in(R2in), .R5in(R5in), .R6in(R6in),
    .Zin(Zin), .PCin(PCin), .MDRin(MDRin), .Yin(Yin),

    .R0in(1'b0), .R1in(1'b0), .R3in(1'b0), .R4in(1'b0),
    .R7in(1'b0), .R8in(1'b0), .R9in(1'b0), .R10in(1'b0), .R11in(1'b0),
    .R12in(1'b0), .R13in(1'b0), .R14in(1'b0), .R15in(1'b0),
    .Zhighin(Zin), .Zlowin(Zin),
    .HIin(1'b0), .LOin(1'b0),
    .InPortin(1'b0), .Cin(1'b0),

    .ADD(ADD), .SUB(SUB), .MUL(MUL), .DIV(DIV),
    .SHR(SHR), .SHRA(SHRA), .SHL(SHL), .ROR(ROR), .ROL(ROL),
    .AND(AND), .OR(OR), .NEG(NEG), .NOT(NOT)
  );

  initial begin Clock=0; forever #10 Clock=~Clock; end

  always @(posedge Clock) begin
    case(Present_state)
      Default:     Present_state <= Reg_load1a;
      Reg_load1a:  Present_state <= Reg_load1b;
      Reg_load1b:  Present_state <= Reg_load2a;
      Reg_load2a:  Present_state <= Reg_load2b;
      Reg_load2b:  Present_state <= T0;
      T0:          Present_state <= T1;
      T1:          Present_state <= T2;
      T2:          Present_state <= T3;
      T3:          Present_state <= T4;
      T4:          Present_state <= T5;
      default:     Present_state <= Default;
    endcase
  end

  always @(Present_state) begin
    PCout=0; Zlowout=0; Zhighout=0; MDRout=0; R5out=0; R6out=0;
    MARin=0; Zin=0; PCin=0; MDRin=0; IRin=0; Yin=0;
    IncPC=0; Read=0;
    ADD=0; SUB=0; MUL=0; DIV=0; SHR=0; SHRA=0; SHL=0;
    ROR=0; ROL=0; AND=0; OR=0; NEG=0; NOT=0;
    R2in=0; R5in=0; R6in=0;
    Mdatain=32'h0;

    case(Present_state)

      Reg_load1a: begin
        Mdatain=32'h00000034;
        Read=1; MDRin=1; #15 Read=0; MDRin=0;
      end

      Reg_load1b: begin
        MDRout=1; R5in=1; #15 MDRout=0; R5in=0;
      end

      Reg_load2a: begin
        Mdatain=32'h00000045;
        Read=1; MDRin=1; #15 Read=0; MDRin=0;
      end

      Reg_load2b: begin
        MDRout=1; R6in=1; #15 MDRout=0; R6in=0;
      end

      T0: begin
        PCout=1; MARin=1; IncPC=1; Zin=1;
        #15 PCout=0; MARin=0; IncPC=0; Zin=0;
      end

      T1: begin
        Zlowout=1; PCin=1; Read=1; MDRin=1;
        Mdatain=32'hXXXX0000; // <-- REPLACE with your ADD opcode
        #15 Zlowout=0; PCin=0; Read=0; MDRin=0;
      end

      T2: begin
        MDRout=1; IRin=1;
        #15 MDRout=0; IRin=0;
      end

      T3: begin
        R5out=1; Yin=1;
        #15 R5out=0; Yin=0;
      end

      T4: begin
        R6out=1; ADD=1; Zin=1;
        #15 R6out=0; ADD=0; Zin=0;
      end

      T5: begin
        Zlowout=1; R2in=1;
        #15 Zlowout=0; R2in=0;
      end

    endcase
  end

endmodule