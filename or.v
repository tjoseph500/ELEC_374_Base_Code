// OR 
module OR(A_or, B_or, Result_or);

input [31:0] A_or, B_or;
output [31:0] Result_or; 

reg [31:0] Result_or;

integer i;

always@(A_or or B_or)
	begin
		for(i=0; i<32; i=i+1)
		
		begin
			Result_or[i]= A_or[i]|B_or[i];
		end
end
endmodule
