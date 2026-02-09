// Ripple Carry Adder
module adder(A_add, B_add, Result_add);

input [31:0] A_add, B_add;
output [31:0] Result_add; 

reg [31:0] Result_add;
reg [32:0] LocalCarry;

integer i;

always@(A_add or B_add)
begin
	LocalCarry= 32'd0;
	for(i=0; i<32; i=i+1)
	begin
		Result_add[i]= A_add[i]^B_add[i]^LocalCarry[i];
		LocalCarry[i+1] = (A_add[i]&B_add[i]|(LocalCarry[i]&(A_add[i]|B_add[i])));
	end
end
endmodule
