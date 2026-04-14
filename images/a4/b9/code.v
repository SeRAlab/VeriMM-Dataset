module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] load_value,
    input enable,
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else if (load) begin
            count <= load_value;
        end else if (enable) begin
            count <= count + 1;
        end
    end

endmodule