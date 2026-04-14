module shiftreg8(clk, rst, d, q);
    input clk;
    input rst;
    input d;
    output reg [7:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= {q[6:0], d};
    end
endmodule