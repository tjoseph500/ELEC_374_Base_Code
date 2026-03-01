`timescale 1ns/10ps
module datapath_div_tb;

  reg PCout, Zlowout, Zhighout, MDRout, R3out, R1out;
  reg MARin, Zin, PCin, MDRin, IRin, Yin;
  reg IncPC, Read, DIV;
  reg LOin, HIin;
  reg Clock;
  reg [31:0] Mdatain;

  parameter T0=4'b0001, T1=4'b0010, T2=4'b0011,
            T3=4'b0100, T4=4'b0101,
            T5=4'b0110, T6=4'b0111;

  reg [3:0] state = 0;

  datapath DUT( /* same instantiation */ );

  initial begin Clock=0; forever #10 Clock=~Clock; end
  always @(posedge Clock) state <= state + 1;

  always @(state) begin
    PCout=0; Zlowout=0; Zhighout=0; MDRout=0; R3out=0; R1out=0;
    MARin=0; Zin=0; PCin=0; MDRin=0; IRin=0; Yin=0;
    IncPC=0; Read=0; DIV=0; LOin=0; HIin=0;

    case(state)

      T0: begin PCout=1; MARin=1; IncPC=1; Zin=1; end

      T1: begin
        Zlowout=1; PCin=1; Read=1; MDRin=1;
        Mdatain=32'hXXXX0000; // DIV opcode
      end

      T2: begin MDRout=1; IRin=1; end

      T3: begin R3out=1; Yin=1; end

      T4: begin R1out=1; DIV=1; Zin=1; end

      T5: begin Zlowout=1; LOin=1; end   // quotient

      T6: begin Zhighout=1; HIin=1; end // remainder

    endcase
  end

endmodule