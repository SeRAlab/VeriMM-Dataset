module lfsr (
    input clk,
    input rst,
    input en,
    output reg [11:0] lfsr_out);

    parameter SEED = 12'hA3F;
    parameter POLY = 12'hC80;

    always @(posedge clk) begin
        if (rst) begin
            lfsr_out <= SEED;
        end else if (en) begin
            lfsr_out <= {lfsr_out[10:0], ^(lfsr_out & POLY)};
        end
    end
endmodule