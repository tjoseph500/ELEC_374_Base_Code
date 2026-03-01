`timescale 1ns/10ps
module datapath_shr_tb;

  reg PCout, Zlowout, MDRout, R0out;
  reg MARin, Zin, PCin, MDRin, IRin, Yin;
  reg IncPC, Read, SHR;
  reg R7in;
  reg Clock;
  reg [31:0] Mdatain;

  reg [3:0] state=0;

  datapath DUT( /* same style */ );

  initial begin Clock=0; forever #10 Clock=~Clock; end
  always @(posedge Clock) state <= state + 1;

  always @(state) begin
    PCout=0; Zlowout=0; MDRout=0; R0out=0;
    MARin=0; Zin=0; PCin=0; MDRin=0; IRin=0; Yin=0;
    IncPC=0; Read=0; SHR=0; R7in=0;

    case(state)

      1: begin PCout=1; MARin=1; IncPC=1; Zin=1; end

      2: begin
        Zlowout=1; PCin=1; Read=1; MDRin=1;
        Mdatain=32'hXXXX0000; // SHR opcode
      end

      3: begin MDRout=1; IRin=1; end

      4: begin R0out=1; Yin=1; end

      5: begin SHR=1; Zin=1; end

      6: begin Zlowout=1; R7in=1; end

    endcase
  end

endmodule