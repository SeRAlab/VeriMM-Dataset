module SHIFTLEFT4 (A, Z);
input [3:0] A;
output [3:0] Z;

integer i;

always @(*) begin
    Z[0] = A[1];
    Z[1] = A[2];
    Z[2] = A[3];
    Z[3] = 0;
end

endmodule