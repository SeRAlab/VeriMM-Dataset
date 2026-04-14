module top_module(
    input clk,
    input rst,
    input up_down,
    output reg [2:0] count
);reg [2:0] count_reg1;
reg [2:0] count_reg2;

always @(posedge clk) begin
    if (rst) begin
        count_reg1 <= 3'b0;
        count_reg2 <= 3'b0;
    end
    else begin
        count_reg1 <= up_down ? count : count_reg2;
        count_reg2 <= count_reg1;
    end
end

assign count = count_reg2 + (up_down ? 1 : -1);

endmodule