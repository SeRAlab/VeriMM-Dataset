module top_module(
    input clk,
    input rst,
    input en,
    input load,
    input [3:0] load_value,
    output reg [3:0] out
);always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b0000;
        end else if (load) begin
            out <= load_value;
        end else if (en) begin
            out <= out + 1;
        end
    end

endmodule