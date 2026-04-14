module d_flip_flop(clk, reset, d, q);

    input clk;
    input reset;
    input d;
    output q;
    reg q;
    initial q = 0;

    always @(posedge clk)
        begin
            if (reset)
                q <= 0;
            else
                q <= d;
        end

endmodule