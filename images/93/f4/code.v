module top_module(
    input clk,
    input reset,
    input wenb,
    input [7:0] in_data,
    output reg [7:0] reg_out
);always @(posedge clk) begin
        if (reset) begin
            reg_out <= 8'h00;
        end else if (wenb) begin
            reg_out <= in_data;
        end
    end

endmodule