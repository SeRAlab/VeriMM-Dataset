module counter_3bit (
    input clk,
    input en,
    input reset,
    output reg [2:0] q
);

always @(posedge clk)
    if (reset)
        q <= 3'b000;
    else if (en)
        q <= q + 1;

endmodule