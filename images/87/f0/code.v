module binary_adder (
    input [1:0] x,
    input [1:0] y,
    output reg [1:0] sum,
    output reg carry);always @(*) begin
        {carry, sum} = x + y;
    end

endmodule