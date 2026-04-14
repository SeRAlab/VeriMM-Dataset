module top_module(
    input [7:0] A,
    input [7:0] B,
    input signed_unsigned,
    output reg [7:0] sum,
    output reg carry_out
);// Internal wire to hold the result of the addition
    wire [8:0] full_sum;

    // Perform the addition (A + B) considering signed and unsigned
    assign full_sum = {1'b0, A} + {1'b0, B};  // Concatenate 0 for carry_out

    always @(*) begin
        // Assign outputs
        sum = full_sum[7:0];
        carry_out = full_sum[8]; // Assign carry_out from the MSB
    end

endmodule