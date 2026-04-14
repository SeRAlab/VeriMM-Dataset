module counter4bit(clk, rst, count);
    input clk;
    input rst;
    output reg [3:0] count;

    always @(posedge clk) begin
        if (rst)
            count <= 4'b0;
        else
            count <= count + 1;
    end
endmodule