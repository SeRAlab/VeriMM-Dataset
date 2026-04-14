module top_module(
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [1:0] data_out
);always @(posedge clk) begin
        if (reset) begin
            data_out <= 2'b0;
        end else begin
            if (data_in[3:2] >= 2) begin
                data_out <= data_in[1:0] + 2'b01;
            end else begin
                data_out <= data_in[1:0];
            end
        end
    end

endmodule