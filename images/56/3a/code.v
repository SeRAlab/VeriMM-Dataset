module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] sum,
    output reg carry_out  // Changed carry_out to reg
);reg [3:0] carry;

    always @(*) begin
        {carry_out, sum} = A + B + carry;  // Updated to handle carry out as part of the addition
    end

    always @(posedge carry_out) begin
        carry <= carry;  // This line may not be necessary; consider removing it
    end

endmodule