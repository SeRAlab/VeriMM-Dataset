module counter_4bit(
    input clk,
    input rst,

    output reg [3:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 4'b0000;   // reset
    else
        q <= q + 1;     // increment counter
end

endmodule