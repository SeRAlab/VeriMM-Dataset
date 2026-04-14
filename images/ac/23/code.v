module d_flip_flop_4bit
(
    input clk,
    input en,
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (en) begin
        q <= d;
    end
end

endmodule