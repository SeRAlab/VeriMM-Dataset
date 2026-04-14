module d_flip_flop (
    input clk,
    input d,
    output reg q
);

    // D flip-flop logic
    always @(posedge clk) begin
        q <= d;
    end

endmodule