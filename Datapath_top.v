module Datapath(
  input wire PCout, Zlowout, MDRout, R5out, R6out,
  input wire MARin, Zin, PCin, MDRin, IRin, Yin,
  input wire IncPC, Read, AND,
  input wire R2in, R5in, R6in,
  input wire Clock,
  input wire [31:0] Mdatain
);

  // Instantiate your REAL datapath core (datapath.v)
  // Tie every unused control low.
  datapath DUT(
    .clock(Clock),
    .clear(1'b0),

    // phase-1 ports added to datapath
    .MARin(MARin),
    .IRin(IRin),
    .IncPC(IncPC),
    .Read(Read),
    .Mdatain(Mdatain),

    // outs used by TB
    .PCout(PCout),
    .Zlowout(Zlowout),
    .MDRout(MDRout),
    .R5out(R5out),
    .R6out(R6out),

    // outs unused
    .R0out(1'b0), .R1out(1'b0), .R2out(1'b0), .R3out(1'b0), .R4out(1'b0),
    .R7out(1'b0), .R8out(1'b0), .R9out(1'b0), .R10out(1'b0), .R11out(1'b0),
    .R12out(1'b0), .R13out(1'b0), .R14out(1'b0), .R15out(1'b0),
    .HIout(1'b0), .LOout(1'b0), .Zhighout(1'b0),
    .InPortout(1'b0), .Cout(1'b0),

    // ins used by TB
    .R2in(R2in),
    .R5in(R5in),
    .R6in(R6in),
    .Zin(Zin),
    .PCin(PCin),
    .MDRin(MDRin),
    .Yin(Yin),

    // ins unused
    .R0in(1'b0), .R1in(1'b0), .R3in(1'b0), .R4in(1'b0),
    .R7in(1'b0), .R8in(1'b0), .R9in(1'b0), .R10in(1'b0), .R11in(1'b0),
    .R12in(1'b0), .R13in(1'b0), .R14in(1'b0), .R15in(1'b0),
    .HIin(1'b0), .LOin(1'b0),
    .Zhighin(Zin), .Zlowin(Zin),
    .InPortin(1'b0), .Cin(1'b0),

    // ALU ops: only AND driven
    .AND(AND),
    .ADD(1'b0), .SUB(1'b0), .MUL(1'b0), .DIV(1'b0),
    .SHR(1'b0), .SHRA(1'b0), .SHL(1'b0),
    .ROR(1'b0), .ROL(1'b0),
    .OR(1'b0), .NEG(1'b0), .NOT(1'b0)
  );

endmodule