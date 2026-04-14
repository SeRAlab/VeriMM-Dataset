module binary_xnor_gate (
    input [1:0] z,
    input [1:0] w,
    output reg [1:0] xnor_out);always @(*) begin
        xnor_out = ~(z ^ w);
    end

endmodule