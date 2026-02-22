//OneCom 
module oneCom(A_oneCom, Result_oneCom);

input [31:0] A_oneCom;
output [31:0] Result_oneCom; 

reg [31:0] Result_oneCom;

integer i;

always@(A_oneCom)
	begin
		for(i=0; i<32; i=i+1)
		begin
			Result_oneCom[i]= ~A_oneCom[i];
		end
end
endmodule
