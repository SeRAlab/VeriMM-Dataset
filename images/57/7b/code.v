module lfsr(
    input clk,
    input rst_n,
    output reg [5:0] lfsr_out
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            lfsr_out <= 6'b000001;
        end else begin
            lfsr_out <= {lfsr_out[4:0], lfsr_out[5] ^ lfsr_out[0]};
        end
    end
endmodule