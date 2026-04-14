module reg_16bit
(
    input clk,
    input rst,
    input enable,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk) begin
    if (rst)
        data_out <= 16'b0;
    else if (enable)
        data_out <= data_in;
end

endmodule