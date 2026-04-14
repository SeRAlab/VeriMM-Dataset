module top_module(
    input clk,
    input rst,
    input start,
    input [31:0] a,
    input [31:0] b,
    output [63:0] p,
    output reg done
);reg [31:0] a_reg;
reg [31:0] b_reg;
reg [63:0] p_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 0;
        p_reg <= 0;
    end else if (start) begin
        a_reg <= a;
        b_reg <= b;
        p_reg <= a_reg * b_reg;
        done <= 1;
    end else begin
        p_reg <= p_reg;
        done <= done;
    end
end

assign p = p_reg;

endmodule