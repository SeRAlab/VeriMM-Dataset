module counter_2bit_en(
    input clk,
    input rst,
    input en,

    output reg [1:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 2'b00;   // reset
    else if (en)
        q <= q + 1;   // increment counter
end

endmodule