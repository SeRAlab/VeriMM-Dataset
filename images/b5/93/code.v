module top_module(A, B, Z, OVF);input [1:0] A;
input [1:0] B;
output reg [1:0] Z; // Change output Z to reg type
output OVF;

wire [2:0] sum;
assign sum = A + B;
assign OVF = (sum > 3);

always @* begin
    if (sum > 3)
        Z = 2'b11;
    else
        Z = sum[1:0];
end

endmodule