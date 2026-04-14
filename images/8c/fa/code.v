module counter3bit(clk, rst, q);
    input clk;
    input rst;
    output reg [2:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 3'b000;
        else
            q <= q + 1;
    end
endmodule