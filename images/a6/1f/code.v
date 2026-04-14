module top_module (
    input clk,
    input d,
    output reg q
);

    // D flip-flop logic
    always @(posedge clk) begin
        q <= d;
    end

endmodule