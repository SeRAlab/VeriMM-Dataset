module binary_nor_gate (
    input [2:0] k,
    input [2:0] l,
    output reg [2:0] nor_out);always @(*) begin
        nor_out = ~(k | l);
    end

endmodule