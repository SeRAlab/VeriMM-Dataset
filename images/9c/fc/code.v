module top_module(
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg data_out
);always @(posedge clk, posedge rst) begin
        if (rst) begin
            data_out <= 1'b0;
        end else begin
            data_out <= data_in;
        end
    end

endmodule