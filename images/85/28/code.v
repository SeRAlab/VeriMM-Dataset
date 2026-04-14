module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);reg [3:0] count_reg1, count_reg2, count_reg3;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
        count_reg3 <= 4'b0;
    end
    else if (enable) begin
        count_reg1 <= count + 4'b1;
        count_reg2 <= count_reg1;
        count_reg3 <= count_reg2;
    end
end

assign count = enable ? count_reg3 : count;

endmodule