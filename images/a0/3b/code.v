module d_flip_flop (
    input d,
    input clk,
    input reset,
    output reg q
);

    // D flip-flop logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule