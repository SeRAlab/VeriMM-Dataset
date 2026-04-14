module LFSR (
    input clk,
    input reset,
    output reg [4:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 5'b00001; // Initial state
        end else begin
            out <= {out[3:0], out[4] ^ out[2]}; // Feedback polynomial: x^5 + x^3 + 1
        end
    end
endmodule