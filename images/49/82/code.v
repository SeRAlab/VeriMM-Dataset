module top_module
(
    input clk,
    input areset,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);always @(posedge clk or posedge areset)
        if (areset) begin
            data_out <= 8'b0;
        end else if (load) begin
            data_out <= data_in;
        end
endmodule