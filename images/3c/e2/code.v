module lfsr_5bit (
    input wire clk,
    input wire reset,
    input wire [4:0] seed,
    output reg [4:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else begin
            lfsr_out <= {lfsr_out[3:0], (lfsr_out[4] ^ lfsr_out[2])};
        end
    end
endmodule