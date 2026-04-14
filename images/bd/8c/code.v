module counter_12bit(clk, rst, en, q);

    input clk;
    input rst;
    input en;
    output [11:0] q;
    reg [11:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 12'b000000000000;
        else if (en)
            q <= q + 1;
    end

endmodule