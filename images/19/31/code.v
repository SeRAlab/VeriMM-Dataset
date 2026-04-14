module RRT_Node (
    input clk,
    input reset,
    input [7:0] x_in,
    input [7:0] y_in,
    output reg [7:0] x_out,
    output reg [7:0] y_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_out <= 8'b0;
            y_out <= 8'b0;
        end else begin
            x_out <= x_in;
            y_out <= y_in;
        end
    end
endmodule