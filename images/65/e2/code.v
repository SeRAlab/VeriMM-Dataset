module counter_4bit(
    input clk, rst, en,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b0;
        else if (en)
            q <= q + 1;
    end
endmodule