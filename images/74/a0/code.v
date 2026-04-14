module counter_8bit_up_down(
    input clk, rst, dir,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b00000000;
        else if (dir)
            q <= q + 1;
        else
            q <= q - 1;
    end
endmodule