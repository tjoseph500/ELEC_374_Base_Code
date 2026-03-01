`timescale 1ns/10ps
module datapath_neg_tb;

  reg PCout, Zlowout, MDRout, R7out;
  reg MARin, Zin, PCin, MDRin, IRin;
  reg IncPC, Read, NEG;
  reg R4in;
  reg Clock;
  reg [31:0] Mdatain;

  reg [3:0] state=0;

  datapath DUT( /* same instantiation */ );

  initial begin Clock=0; forever #10 Clock=~Clock; end
  always @(posedge Clock) state <= state + 1;

  always @(state) begin
    PCout=0; Zlowout=0; MDRout=0; R7out=0;
    MARin=0; Zin=0; PCin=0; MDRin=0; IRin=0;
    IncPC=0; Read=0; NEG=0; R4in=0;

    case(state)

      1: begin PCout=1; MARin=1; IncPC=1; Zin=1; end

      2: begin
        Zlowout=1; PCin=1; Read=1; MDRin=1;
        Mdatain=32'hXXXX0000; // NEG opcode
      end

      3: begin MDRout=1; IRin=1; end

      4: begin R7out=1; NEG=1; Zin=1; end

      5: begin Zlowout=1; R4in=1; end

    endcase
  end

endmodule