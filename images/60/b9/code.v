module register_with_enable(
    input clk,
    input rst_n,
    input en,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 8'b00000000;
    else if (en)
        q <= d;
end

endmodule