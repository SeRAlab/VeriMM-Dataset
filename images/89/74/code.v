module top_module (
    input clk,
    output reg [3:0] q
);

    // 4-bit binary counter logic
    always @(posedge clk) begin
        q <= q + 1;
    end

endmodule