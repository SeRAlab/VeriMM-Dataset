module shiftreg16(d, clk, rst, q);
    input d;
    input clk;
    input rst;
    output reg [15:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 16'b0;
        else
            q <= {q[14:0], d};
    end
endmodule