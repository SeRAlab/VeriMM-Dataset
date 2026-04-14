module shift_register_8bit(
    input clk, rst, d,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else
            q <= {q[6:0], d};
    end
endmodule