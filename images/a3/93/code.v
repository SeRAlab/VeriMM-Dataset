module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Y
);always @(*) begin
    Y = A + B;
    if(Y >= 16) Y = Y - 16;
end

endmodule