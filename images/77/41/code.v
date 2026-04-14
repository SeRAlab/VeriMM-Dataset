module reg8bit(d, clk, rst, q);
    input [7:0] d;
    input clk;
    input rst;
    output reg [7:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule