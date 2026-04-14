module counter_3bit(
    input clk, rst, en,
    output reg [2:0] q);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 3'b0;
        else if (en)
            q <= q + 1;
    end
endmodule