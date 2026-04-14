module counter_3bit_ud(
    input clk,
    input rst,
    input up_down,

    output reg [2:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 3'b000;   // reset
    else if (up_down)
        q <= q + 1;    // count up
    else
        q <= q - 1;    // count down
end

endmodule