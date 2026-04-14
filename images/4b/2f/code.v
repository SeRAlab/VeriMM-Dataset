module register_8bit_sync_reset_enable(
    input clk,
    input rst,
    input enable,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 8'b0000_0000;
    end else if (enable) begin
        data_out <= data_in;
    end
end

endmodule