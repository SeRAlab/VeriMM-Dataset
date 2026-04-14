module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] out_comb_logic
);always @* begin
    out_comb_logic = a ^ b;
end

endmodule