module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q
);reg [3:0] count_reg1, count_reg2, count_reg3, count_reg4;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 4'b0000;
        count_reg2 <= 4'b0000;
        count_reg3 <= 4'b0000;
        count_reg4 <= 4'b0000;
    end
    else if (enable) begin
        count_reg1 <= Q + 4'b0001;
    end
end

assign Q = count_reg4;

always @(posedge clk) begin
    count_reg2 <= count_reg1;
end

always @(posedge clk) begin
    count_reg3 <= count_reg2;
end

always @(posedge clk) begin
    count_reg4 <= count_reg3;
end

endmodule