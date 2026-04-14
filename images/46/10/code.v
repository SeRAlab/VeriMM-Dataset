module top_module(A, B, C_IN, Y, C_OUT);input [3:0] A;
input [3:0] B;
input C_IN;
output [3:0] Y;
output C_OUT;

reg [3:0] Y;
reg C_OUT;

always @* begin
    Y = A + B + C_IN;
    if (Y > 15) begin
        C_OUT = 1;
    end else begin
        C_OUT = 0;
    end
end

endmodule