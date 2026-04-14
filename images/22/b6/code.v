module lfsr_32bit (
    input clk,
    input reset,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'h1; // Initial non-zero value
        end else begin
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[17] ^ lfsr_out[13]};
        end
    end
endmodule