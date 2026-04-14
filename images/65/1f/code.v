module d_flip_flop(clk, d, q);

    input  clk, d;
    output reg q;

    always @(posedge clk) begin
        q <= d;
    end

endmodule