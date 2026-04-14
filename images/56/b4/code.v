module top_module(
    input clk,
    input reset,
    input signed [31:0] input_data,
    output reg signed [31:0] output_data
);always @(posedge clk) begin
        if (reset) begin
            output_data <= 0;
        end else begin
            output_data <= ((input_data * 3) + 7 - 2) ** 2;
        end
    end

endmodule