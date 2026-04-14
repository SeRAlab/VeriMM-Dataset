module counter_8bit(clk, rst, en, count);
    input clk;
    input rst;
    input en;
    output reg [7:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule