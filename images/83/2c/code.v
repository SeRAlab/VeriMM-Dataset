module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,
    output reg C
);reg [3:0] temp;

always @(*) begin
    temp = A ^ B;
    S = temp ^ S;
    C = (A & B) | (temp & S);
end

endmodule