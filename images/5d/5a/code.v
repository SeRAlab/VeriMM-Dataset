module top_module
(
    input clk,
    input preset,
    input enable,
    input [3:0] preset_val,
    output reg [3:0] count
);always @(posedge clk or posedge preset)
        if (preset) begin
            count <= preset_val;
        end else if (enable) begin
            count <= count + 1;
        end
endmodule