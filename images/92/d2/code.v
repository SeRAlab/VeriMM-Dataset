module top_module (
    input clk,
    input k,
    output reg l);

always @(posedge clk) begin
    l <= k;
end

endmodule