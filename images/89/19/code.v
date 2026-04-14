module t_flip_flop(
    input clk,
    input clear_n,
    input t,
    output reg q
    );
    
    always @(posedge clk or negedge clear_n) begin
        if (!clear_n)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule