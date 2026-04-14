module d_ff (
    input clk,
    input reset,
    input d,
    output reg q
);

    // Flip-flop logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule