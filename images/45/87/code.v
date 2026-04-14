module register_16bit
(
    input clk,
    input rst_n,
    input enable,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 16'd0;
    end else if (enable) begin
        data_out <= data_in;
    end
end

endmodule