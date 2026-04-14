module lfsr (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [7:0] seed,
    output reg [7:0] out
);
    wire feedback;

    assign feedback = out[7] ^ out[5] ^ out[4] ^ out[6];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= seed; // load seed on reset
        end else if (enable) begin
            out <= {out[6:0], feedback}; // shift and insert feedback
        end
    end
endmodule