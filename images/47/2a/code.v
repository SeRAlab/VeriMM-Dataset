module d_flip_flop (
    input clk,
    input reset,
    input d,
    output reg q
);

    // D Flip-Flop logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule