module top_module(
    input G2,
    input G1,
    input G0,
    output reg [2:0] B
);always @ (G2, G1, G0) begin
    B[2] = G2;
    B[1] = G2 ^ G1;
    B[0] = G1 ^ G0;
end

endmodule