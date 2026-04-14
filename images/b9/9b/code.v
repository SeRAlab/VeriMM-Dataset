module top_module(
    input clk,
    input reset,
    input parallel_load,
    input shift,
    input [3:0] input_data,
    output reg [3:0] output_data
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_data <= 4'b0;
        end else if (parallel_load) begin
            output_data <= input_data;
        end else if (shift) begin
            output_data <= {output_data[2:0], 1'b0};
        end
    end

endmodule