module top_module(
    input clk,
    input async_reset,
    input [1:0] enable,
    output reg [1:0] count
);reg [1:0] count_reg1, count_reg2;

always @(posedge clk) begin
    if (async_reset) begin
        count_reg1 <= 2'b00;
        count_reg2 <= 2'b00;
    end
    else begin
        count_reg1 <= count_reg2;
        count_reg2 <= count;
    end
end

always @(*) begin
    case (enable)
        2'b00: count = count_reg1;
        2'b01: count = count_reg1 + 2'b01;
        2'b10: count = count_reg1 - 2'b01;
        default: count = count_reg1;
    endcase
end

endmodule