module lfsr (
    input clk,
    input rst_n,
    output reg [9:0] lfsr_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        lfsr_out <= 10'b1111111111;
    else begin
        lfsr_out <= {lfsr_out[8:0], lfsr_out[9] ^ lfsr_out[8]};
    end
end

endmodule