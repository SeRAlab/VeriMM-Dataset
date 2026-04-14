module top_module(A, Z);input [3:0] A;
output reg [3:0] Z;  // Change to reg type because we are assigning values in an always block

always @(*) begin
    Z[0] = A[1];
    Z[1] = A[2];
    Z[2] = A[3];
    Z[3] = 0;
end

endmodule