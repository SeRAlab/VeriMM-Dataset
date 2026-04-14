module load_reg (
    input [3:0] d,
    input clk,
    input en,
    output reg [3:0] q);always @(posedge clk) begin
    if (en)
        q <= d;
end
endmodule