module d_flip_flop(
    input d,
    input clk,
    input clr,
    output reg q
);

    always @(posedge clk or posedge clr) begin
        if (clr)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule