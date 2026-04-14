module d_flip_flop (
    input clk,
    input clear_n,
    input d,
    output reg q
);

    always @(posedge clk or negedge clear_n) begin
        if (!clear_n)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule