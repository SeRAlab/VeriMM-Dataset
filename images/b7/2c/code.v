module top_module
(
    input clk,
    input areset,
    input [15:0] data_in,
    output reg [15:0] data_out
);always @(posedge clk or posedge areset)
        if (areset) begin
            data_out <= 16'b0;
        end else begin
            data_out <= data_in;
        end
endmodule