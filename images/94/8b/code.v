module counter_6bit_down(
    input clk, rst, en,
    output reg [5:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 6'b111111;
        else if (en)
            q <= q - 1;
    end
endmodule