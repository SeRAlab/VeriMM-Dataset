module top_module(
    input clk,
    input sin,
    output reg [1:0] q
);

    always @(posedge clk) begin
        q <= {q[0], sin};  // Shift register
    end

endmodule