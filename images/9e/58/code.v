module lfsr (
    input clk,
    input clr,
    output reg [7:0] lfsr_out);

    always @(posedge clk) begin
        if (clr) begin
            lfsr_out <= 8'b1; // Initial seed
        end else begin
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5]};
        end
    end
endmodule