module lfsr(clk, reset, seed, out);
    input clk, reset;
    input [4:0] seed;
    output reg [4:0] out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= seed; // Initialize with seed value
        end else begin
            out <= {out[3:0], out[4] ^ out[2]}; // Feedback from taps at 5 and 3
        end
    end
endmodule