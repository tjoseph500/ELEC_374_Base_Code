// AND 
module AND(A_and, B_and, Result_and);

input [31:0] A_and, B_and;
output [31:0] Result_and; 

reg [31:0] Result_and;

integer i;

always@(A_and or B_and)
	begin
		for(i=0; i<32; i=i+1)
		
		begin
			Result_and[i]= A_and[i]&B_and[i];
		end
end
endmodule
