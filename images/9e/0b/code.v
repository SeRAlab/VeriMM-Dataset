module top_module(
    input clk,
    input up_down,
    input enable,
    input reset,
    output reg [2:0] count
);reg [2:0] count_reg1;
reg [2:0] count_reg2;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 3'b0;
        count_reg2 <= 3'b0;
    end
    else if (enable) begin
        count_reg1 <= up_down ? count_reg2 - 3'b1 : count_reg2 + 3'b1;
        count_reg2 <= count_reg1;
    end
end

assign count = count_reg2;

endmodule