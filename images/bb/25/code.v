module top_module (
    input clk,
    input s,
    output reg [2:0] q
);

    // 3-bit shift register logic
    always @(posedge clk) begin
        q <= {q[1:0], s};
    end

endmodule