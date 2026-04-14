module counter_2bit_down(
    input clk, rst,
    output reg [1:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 2'b11;
        else
            q <= q - 1;
    end
endmodule