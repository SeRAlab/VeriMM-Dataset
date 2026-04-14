module top_module (
    input clk,
    input [3:0] d,
    output reg [3:0] q
);

    // 4-bit shift register logic
    always @(posedge clk) begin
        q <= {q[2:0], d[0]};
    end

endmodule