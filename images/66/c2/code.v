module counter_2bit(
    input clk, rst, up_dn,
    output reg [1:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 2'b0;
        else if (up_dn)
            q <= q + 1;
        else
            q <= q - 1;
    end
endmodule