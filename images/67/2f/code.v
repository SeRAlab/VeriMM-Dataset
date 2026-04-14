module top_module(urng_seed1, urng_seed2, urng_seed3, clk, reset, out, valid);input [31:0] urng_seed1;
input [31:0] urng_seed2;
input [31:0] urng_seed3;
input clk, reset;
output reg [31:0] out;
output reg valid;

reg [31:0] b1, b2, b3, seed1, seed2, seed3, seed4;

initial begin
    out = 0;
    valid = 0;
    seed1 = 0;
    seed2 = 0;
    seed3 = 0;
    seed4 = 0;
    b1 = 0;
    b2 = 0;
    b3 = 0;
end

always @(posedge clk, posedge reset) begin
    if (reset) begin
        out <= 0;
        valid <= 0;
    end else begin
        // Generate LFSR outputs
        b1 <= (((urng_seed1 << 13) ^ urng_seed1) >> 19);
        seed1 <= (((urng_seed1 & 'hFFFFFFFE) << 12) ^ b1);
        b2 <= (((urng_seed2 << 2) ^ urng_seed2) >> 25);
        seed2 <= (((urng_seed2 & 'hFFFFFFF8) << 4) ^ b2);
        b3 <= (((urng_seed3 << 3) ^ urng_seed3) >> 11);
        seed3 <= (((urng_seed3 & 'hFFFFFFF0) << 17) ^ b3);
        
        // Combine LFSR outputs to generate pseudo-random number
        seed4 <= seed1 ^ seed2;
        out <= seed4 ^ seed3;
        valid <= 1;
    end
end

endmodule