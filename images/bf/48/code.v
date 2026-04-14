module top_module(
    input clk,
    input reset,
    input up_down,
    output reg [3:0] count
);reg [3:0] count_reg1, count_reg2;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
    end
    else begin
        count_reg1 <= count;
        if (up_down) begin
            count_reg2 <= count_reg1 + 1;
        end
        else begin
            count_reg2 <= count_reg1 - 1;
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end
    else begin
        count <= count_reg2;
    end
end

endmodule