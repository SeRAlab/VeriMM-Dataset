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
        count_reg1 <= count;
        count_reg2 <= count_reg1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        count <= 3'b0;
    end
    else begin
        if (up_down) begin
            count <= count_reg2 + 3'b1;
        end
        else begin
            count <= count_reg2 - 3'b1;
        end
    end
end

endmodule