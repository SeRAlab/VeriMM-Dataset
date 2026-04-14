module top_module(
    input [3:0] data_in,
    input clk,
    input rst,
    output reg [1:0] data_out
);always @(posedge clk) begin
        if (rst) begin
            data_out <= 0;
        end else begin
            data_out <= data_in[3:2];
        end
    end

endmodule