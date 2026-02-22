// 32-bit Rotate
module rotate32(A, dir, Result);

input  [31:0] A;
input  dir;           // 0 = rotate left, 1 = rotate right
output [31:0] Result;

reg [31:0] Result;

always @(A or dir)
begin
    if (dir == 1'b0)   // Rotate Left
    begin
        Result[31] = A[30];
        Result[30] = A[29];
        Result[29] = A[28];
        Result[28] = A[27];
        Result[27] = A[26];
        Result[26] = A[25];
        Result[25] = A[24];
        Result[24] = A[23];
        Result[23] = A[22];
        Result[22] = A[21];
        Result[21] = A[20];
        Result[20] = A[19];
        Result[19] = A[18];
        Result[18] = A[17];
        Result[17] = A[16];
        Result[16] = A[15];
        Result[15] = A[14];
        Result[14] = A[13];
        Result[13] = A[12];
        Result[12] = A[11];
        Result[11] = A[10];
        Result[10] = A[9];
        Result[9]  = A[8];
        Result[8]  = A[7];
        Result[7]  = A[6];
        Result[6]  = A[5];
        Result[5]  = A[4];
        Result[4]  = A[3];
        Result[3]  = A[2];
        Result[2]  = A[1];
        Result[1]  = A[0];
        Result[0]  = A[31]; 
    end
    else               // Rotate Right
    begin
        Result[31] = A[0];   
        Result[30] = A[31];
        Result[29] = A[30];
        Result[28] = A[29];
        Result[27] = A[28];
        Result[26] = A[27];
        Result[25] = A[26];
        Result[24] = A[25];
        Result[23] = A[24];
        Result[22] = A[23];
        Result[21] = A[22];
        Result[20] = A[21];
        Result[19] = A[20];
        Result[18] = A[19];
        Result[17] = A[18];
        Result[16] = A[17];
        Result[15] = A[16];
        Result[14] = A[15];
        Result[13] = A[14];
        Result[12] = A[13];
        Result[11] = A[12];
        Result[10] = A[11];
        Result[9]  = A[10];
        Result[8]  = A[9];
        Result[7]  = A[8];
        Result[6]  = A[7];
        Result[5]  = A[6];
        Result[4]  = A[5];
        Result[3]  = A[4];
        Result[2]  = A[3];
        Result[1]  = A[2];
        Result[0]  = A[1];
    end
end

endmodule
