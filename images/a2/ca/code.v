module lfsr(
    input wire clk,
    input wire rst,
    output reg [11:0] lfsr_out
);

always @(posedge clk) begin
    if (rst) begin
        lfsr_out <= 12'b000000000001;
    end else begin
        lfsr_out <= {lfsr_out[10:0], lfsr_out[11] ^ lfsr_out[3]};
    end
end

endmodule