module shift_register (
    input clk,
    input rst_n,
    input en,
    output reg [15:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 16'b0000000000000000;
    else if (en)
        q <= q >> 1;
end

endmodule