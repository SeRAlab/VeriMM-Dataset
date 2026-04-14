module top_module (
    input clk,
    input t,
    output reg q
);

    // T flip-flop logic
    always @(posedge clk) begin
        if (t) begin
            q <= ~q;
        end
    end

endmodule