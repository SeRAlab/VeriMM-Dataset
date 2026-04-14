module top_module (
    input clk,
    input sh,
    input d,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (sh)
            q <= {q[2:0], d};
    end
endmodule