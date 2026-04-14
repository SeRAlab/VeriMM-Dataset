module counter_4bit_down(
    input clk, rst, en,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b1111;
        else if (en)
            q <= q - 1;
    end
endmodule