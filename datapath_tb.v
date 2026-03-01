`timescale 1ns/10ps

module datapath_tb;

  // TB-driven controls (subset used by the AND instruction sequence)
  reg PCout, Zlowout, MDRout, R5out, R6out;
  reg MARin, Zin, PCin, MDRin, IRin, Yin;
  reg IncPC, Read, AND;
  reg R2in, R5in, R6in;
  reg Clock;
  reg [31:0] Mdatain;

  // FSM states
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

  // Instantiate YOUR real datapath (module name: datapath)
  datapath DUT(
    .clock(Clock),
    .clear(1'b0),

    // Phase-1 fetch ports (must exist in your updated datapath.v)
    .MARin(MARin),
    .IRin(IRin),
    .IncPC(IncPC),
    .Read(Read),
    .Mdatain(Mdatain),

    // OUT selects used
    .PCout(PCout),
    .Zlowout(Zlowout),
    .MDRout(MDRout),
    .R5out(R5out),
    .R6out(R6out),

    // OUT selects unused
    .R0out(1'b0), .R1out(1'b0), .R2out(1'b0), .R3out(1'b0), .R4out(1'b0),
    .R7out(1'b0), .R8out(1'b0), .R9out(1'b0), .R10out(1'b0), .R11out(1'b0),
    .R12out(1'b0), .R13out(1'b0), .R14out(1'b0), .R15out(1'b0),
    .HIout(1'b0), .LOout(1'b0), .Zhighout(1'b0),
    .InPortout(1'b0), .Cout(1'b0),

    // IN enables used
    .R2in(R2in),
    .R5in(R5in),
    .R6in(R6in),
    .Zin(Zin),
    .PCin(PCin),
    .MDRin(MDRin),
    .Yin(Yin),

    // IN enables unused
    .R0in(1'b0), .R1in(1'b0), .R3in(1'b0), .R4in(1'b0),
    .R7in(1'b0), .R8in(1'b0), .R9in(1'b0), .R10in(1'b0), .R11in(1'b0),
    .R12in(1'b0), .R13in(1'b0), .R14in(1'b0), .R15in(1'b0),
    .HIin(1'b0), .LOin(1'b0),
    .Zhighin(Zin),   // safe for later ops too
    .Zlowin(Zin),
    .InPortin(1'b0), .Cin(1'b0),

    // ALU ops: only AND is used here
    .AND(AND),
    .ADD(1'b0), .SUB(1'b0), .MUL(1'b0), .DIV(1'b0),
    .SHR(1'b0), .SHRA(1'b0), .SHL(1'b0),
    .ROR(1'b0), .ROL(1'b0),
    .OR(1'b0), .NEG(1'b0), .NOT(1'b0)
  );

  // Clock
  initial begin
    Clock = 0;
    forever #10 Clock = ~Clock;
  end

  // State advance on posedge
  always @(posedge Clock) begin
    case (Present_state)
      Default:     Present_state <= Reg_load1a;
      Reg_load1a:  Present_state <= Reg_load1b;
      Reg_load1b:  Present_state <= Reg_load2a;
      Reg_load2a:  Present_state <= Reg_load2b;
      Reg_load2b:  Present_state <= Reg_load3a;
      Reg_load3a:  Present_state <= Reg_load3b;
      Reg_load3b:  Present_state <= T0;
      T0:          Present_state <= T1;
      T1:          Present_state <= T2;
      T2:          Present_state <= T3;
      T3:          Present_state <= T4;
      T4:          Present_state <= T5;
      default:     Present_state <= Default;
    endcase
  end

  // Control sequencing
  always @(Present_state) begin
    // default deassert everything each state, then assert what you need
    PCout  = 0; Zlowout = 0; MDRout = 0; R5out = 0; R6out = 0;
    MARin  = 0; Zin    = 0; PCin   = 0; MDRin = 0; IRin = 0; Yin = 0;
    IncPC  = 0; Read   = 0; AND    = 0;
    R2in   = 0; R5in   = 0; R6in   = 0;
    Mdatain = 32'h00000000;

    case (Present_state)
      Default: begin
        // everything already cleared above
      end

      Reg_load1a: begin
        Mdatain = 32'h00000034;
        Read    = 1;
        MDRin   = 1;
        #15 Read = 0; MDRin = 0;
      end

      Reg_load1b: begin
        MDRout = 1; R5in = 1;
        #15 MDRout = 0; R5in = 0;
      end

      Reg_load2a: begin
        Mdatain = 32'h00000045;
        Read    = 1; MDRin = 1;
        #15 Read = 0; MDRin = 0;
      end

      Reg_load2b: begin
        MDRout = 1; R6in = 1;
        #15 MDRout = 0; R6in = 0;
      end

      Reg_load3a: begin
        Mdatain = 32'h00000067;
        Read    = 1; MDRin = 1;
        #15 Read = 0; MDRin = 0;
      end

      Reg_load3b: begin
        MDRout = 1; R2in = 1;
        #15 MDRout = 0; R2in = 0;
      end

      T0: begin
        PCout = 1; MARin = 1; IncPC = 1; Zin = 1;
        #15 PCout = 0; MARin = 0; IncPC = 0; Zin = 0;
      end

      T1: begin
        Zlowout = 1; PCin = 1; Read = 1; MDRin = 1;
        Mdatain = 32'h112B0000; // and R2, R5, R6 (your opcode)
        #15 Zlowout = 0; PCin = 0; Read = 0; MDRin = 0;
      end

      T2: begin
        MDRout = 1; IRin = 1;
        #15 MDRout = 0; IRin = 0;
      end

      T3: begin
        R5out = 1; Yin = 1;
        #15 R5out = 0; Yin = 0;
      end

      T4: begin
        R6out = 1; AND = 1; Zin = 1;
        #15 R6out = 0; AND = 0; Zin = 0;
      end

      T5: begin
        Zlowout = 1; R2in = 1;
        #15 Zlowout = 0; R2in = 0;
      end
    endcase
  end

endmodule