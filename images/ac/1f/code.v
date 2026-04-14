module lfsr (
    input clk,
    input enable,
    output reg [4:0] lfsr_out
);

    always @(posedge clk) begin
        if (enable) begin
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[1]};
        end
    end

endmodule