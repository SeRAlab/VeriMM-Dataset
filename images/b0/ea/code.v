module top_module(
    input clk,
    input reset,
    input direction,
    output reg [2:0] count
);reg [2:0] count_reg1, count_reg2;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 3'b0;
        count_reg2 <= 3'b0;
    end
    else begin
        count_reg1 <= count_reg2;
        if (direction) begin
            count_reg2 <= (count_reg1 == 3'b111) ? 3'b000 : count_reg1 + 1;
        end
        else begin
            count_reg2 <= (count_reg1 == 3'b000) ? 3'b111 : count_reg1 - 1;
        end
    end
end

assign count = count_reg1;

endmodule