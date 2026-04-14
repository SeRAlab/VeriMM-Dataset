module top_module(A, B, Y);input [3:0] A;
input B;
output reg [3:0] Y;

always @ (A, B)
begin
    if(B == 1'b1)
        Y <= 4'b0000;
    else
        Y <= ~A + 4'b0001;
end

endmodule