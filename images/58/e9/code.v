module top_module (
    input clk,
    input reset,
    input d,
    output reg q
);

    // D flip-flop logic
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule