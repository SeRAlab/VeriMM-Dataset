module top_module(
    clk, //clock
    reset, //reset the Multiplier
    x, //First Number to be multiplied 
    y, //Second Number to be multiplied
    prod, //result of multiplication
    ready //signals if the result is ready
);parameter bits = 8;

//----Input Ports---
input clk;
input reset;
input [bits - 1:0] x;
input [bits - 1:0] y;

//---Output Ports--
output reg [(bits * 2) - 1:0] prod;
output reg ready;

//--Internal Data--
reg [7:0] rx;
reg [15:0] ry;

always @(posedge clk) begin
    if (reset) begin
        rx <= x;
        ry <= 16'b0 + y;
        prod <= 16'b0;

    end else begin
        rx <= rx >> 1;
        ry <= ry << 1;
        // If LSB of rx is 1 then "multiply" otherwise no change
        if (rx & 8'b1) begin
            prod <= prod + ry;
        end else begin 
            prod <= prod;
        end

    end
    // When one result reaches 0 nothing left to multiply
    //$display("reset %b ready %b rx %d ry %d prod %d, x %d, y %d", reset, ready, rx, ry, prod, x ,y);
    ready <= !rx || !ry;
end

endmodule