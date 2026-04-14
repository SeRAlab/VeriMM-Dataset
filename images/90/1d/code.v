module top_module (
    input clk,
    input ld,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (ld)
            q <= d;
    end
endmodule