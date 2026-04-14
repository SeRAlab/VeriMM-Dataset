module d_flip_flop (
    input d,
    input clk,
    input en,
    output reg q
);

    always @(posedge clk) begin
        if (en)
            q <= d;
    end

endmodule