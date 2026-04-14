module register
(
    input clk,
    input sclr,
    input [15:0] d,
    output reg [15:0] q
);always @(posedge clk)
    if (sclr) begin
        q <= 16'b0;
    end else begin
        q <= d;
    end
endmodule