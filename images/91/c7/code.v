module top_module(
    input clk,        ///< System clock
    input rst,        ///< Reset, active high and synchronous
    input en,         ///< Filter enable
    input signed [WIDTH-1:0] dataIn,  ///< [WIDTH-1:0] Filter input
    output reg signed [WIDTH-1:0] dataOut ///< [WIDTH-1:0] Filter output
);parameter K0_SHIFT = 6; ///< K0 filter term = 2^-K0_SHIFT
parameter K1_SHIFT = 6; ///< K1 filter term = 2^-K1_SHIFT
parameter WIDTH = 16;   ///< Width of data path
parameter CLAMP = 1;    ///< Set to 1 to clamp the accumulators

reg signed [WIDTH-1:0] acc0;
reg signed [WIDTH-1:0] acc1;
reg signed [WIDTH-1:0] acc2;

integer i;

always @(posedge clk) begin
    if (rst) begin
        acc0 <= 'd0;
        acc1 <= 'd0;
        acc2 <= 'd0;
        dataOut <= 'd0;
    end else if (en) begin
        acc0 <= dataIn + (acc0 >> K0_SHIFT);
        acc1 <= acc0 + (acc1 >> K1_SHIFT);
        acc2 <= acc1 + (acc2 >> K1_SHIFT);
        if (CLAMP && acc2 > ((2**WIDTH-1)>>1)) begin
            dataOut <= (2**WIDTH-1)>>1;
        end else if (CLAMP && acc2 < -((2**WIDTH-1)>>1)) begin
            dataOut <= -((2**WIDTH-1)>>1);
        end else begin
            dataOut <= acc2;
        end
    end
end

endmodule