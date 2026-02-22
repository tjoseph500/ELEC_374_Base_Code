module rotate_right(A, shiftamount, Result);

input  [31:0] A;
input  [4:0] shiftamount;     
output [31:0] Result;

reg [31:0] Result;
reg [31:0] temp;

integer i;

always @(A or shiftamount)
begin
    temp = A;

    for (i = 0; i < shiftamount; i = i + 1)
    begin
        Result[31] = temp[0];
        Result[30] = temp[31];
        Result[29] = temp[30];
        Result[28] = temp[29];
        Result[27] = temp[28];
        Result[26] = temp[27];
        Result[25] = temp[26];
        Result[24] = temp[25];
        Result[23] = temp[24];
        Result[22] = temp[23];
        Result[21] = temp[22];
        Result[20] = temp[21];
        Result[19] = temp[20];
        Result[18] = temp[19];
        Result[17] = temp[18];
        Result[16] = temp[17];
        Result[15] = temp[16];
        Result[14] = temp[15];
        Result[13] = temp[14];
        Result[12] = temp[13];
        Result[11] = temp[12];
        Result[10] = temp[11];
        Result[9]  = temp[10];
        Result[8]  = temp[9];
        Result[7]  = temp[8];
        Result[6]  = temp[7];
        Result[5]  = temp[6];
        Result[4]  = temp[5];
        Result[3]  = temp[4];
        Result[2]  = temp[3];
        Result[1]  = temp[2];
        Result[0]  = temp[1];

        temp = Result;
    end
end

endmodule