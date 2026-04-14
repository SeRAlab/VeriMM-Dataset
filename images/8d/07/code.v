module shift_register_8bit(clk, q);

    input  clk;
    output reg [7:0] q;

    always @(posedge clk) begin
        q <= q << 1;
    end

endmodule