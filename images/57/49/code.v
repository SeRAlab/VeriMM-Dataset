module d_flip_flop (
    input d,
    input clk,
    input reset,
    output reg q
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule