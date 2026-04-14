module lfsr_32bit (
    input clk,
    input rst,
    input [31:0] seed,
    output reg [31:0] out
);
    wire feedback;

    // Feedback polynomial: x^32 + x^22 + x^17 + x^13 + 1
    assign feedback = out[31] ^ out[22] ^ out[17] ^ out[13];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= seed;
        end else begin
            out <= {out[30:0], feedback};  // Shift left and insert feedback
        end
    end
endmodule