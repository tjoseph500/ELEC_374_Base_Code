//NOT 
module NOT(A, Result);

input [31:0] A;
output [31:0] Result; 

reg [31:0] Result;

integer i;

always@(A)
	begin
		for(i=0; i<32; i=i+1)
		begin
			Result[i]= ~A[i];
		end
end
endmodule
