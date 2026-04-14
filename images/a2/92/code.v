module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [4:0] Y
);wire [3:0] sum;
    wire carry_out;

    // The carry-out from the addition of the four bits A and B
    assign {carry_out, sum} = A + B;

    // Assigning the result to the output Y
    always @(*) begin
        Y = {carry_out, sum};
    end

endmodule