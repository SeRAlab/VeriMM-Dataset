module d_flip_flop (
    input wire rst_n,
    input wire clk,
    input wire en,
    input wire d,
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end

endmodule