module jk_flip_flop(
    input       j     ,
    input       k     ,
    input       clk   ,
    input       reset ,
    
    output reg  q
);

    // JK Flip-Flop with synchronous reset
    always @(negedge clk) begin
        if (reset) begin
            q <= 1'b0;
        end else if (j & k) begin
            q <= ~q;
        end else if (j) begin
            q <= 1'b1;
        end else if (k) begin
            q <= 1'b0;
        end
    end
    
endmodule