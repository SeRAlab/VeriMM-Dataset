module reg8bit_clear (
    input [7:0] data_in,
    input clk,
    input clear,
    output reg [7:0] data_out
);always @(posedge clk) begin
    if (clear) begin
        data_out <= 8'b0;
    end else begin
        data_out <= data_in;
    end
end

endmodule