module top_module(
    input clk,
    input rst,
    input en,
    input up,
    output reg [3:0] count
);reg [3:0] count_reg1, count_reg2;

always @(posedge clk) begin
    if (rst) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
    end
    else if (en) begin
        count_reg1 <= up ? count_reg2 + 4'b1 : count_reg2 - 4'b1;
        count_reg2 <= count_reg1;
    end
end

assign count = count_reg2;

endmodule