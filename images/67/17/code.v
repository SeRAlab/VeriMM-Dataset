module top_module(
    input clk,
    input rst,
    input en,
    input signed [15:0] dataIn,
    output signed [15:0] dataOut
);parameter WIDTH = 16;
parameter INT_BITS = 8;
parameter FRAC_BITS = 8;

reg signed [WIDTH-1:0] x1, x2, y1, y2;
reg signed [INT_BITS+FRAC_BITS-1:0] acc0, acc1, acc2;

assign dataOut = acc0 >> FRAC_BITS;

always @(posedge clk) begin
    if (rst) begin
        x1 <= 'd0;
        x2 <= 'd0;
        y1 <= 'd0;
        y2 <= 'd0;
        acc0 <= 'd0;
        acc1 <= 'd0;
        acc2 <= 'd0;
    end
    else if (en) begin
        x2 <= x1;
        x1 <= dataIn;
        y2 <= y1;
        y1 <= dataOut;

        acc0 <= (b0 * x1 + b1 * x2 + b2 * acc1 - a1 * y1 - a2 * y2) << FRAC_BITS;
        acc1 <= acc0;
        acc2 <= acc1;
    end
end

parameter b0 = 256'd128;
parameter b1 = -256'd64;
parameter b2 = 256'd32;
parameter a1 = 256'd128;
parameter a2 = -256'd64;

endmodule