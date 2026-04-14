module tff_async_reset (
    input wire t,
    input wire clk,
    input wire rst,
    output reg q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 1'b0;
    else if (t)
        q <= ~q;
end

endmodule