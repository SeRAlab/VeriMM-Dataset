module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] sum,
    output reg carry_out
);

always @(*) begin
    {carry_out, sum} = a + b;
end

endmodule