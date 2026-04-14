module top_module(
    input clk,
    input reset,
    input [7:0] in_data,
    output reg [7:0] out_data
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_data <= 8'b0;
        end else begin
            out_data <= in_data;  // Example functionality for testing
        end
    end
endmodule