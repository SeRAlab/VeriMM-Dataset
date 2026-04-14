module d_flip_flop (
    input clk,
    input reset,
    input d,
    output reg q
);

    // D flip-flop logic
    always @(posedge clk) begin
        if (reset)
            q <= 0;
        else
            q <= d;
    end

endmodule