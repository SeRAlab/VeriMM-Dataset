module binary_mux (
    input [3:0] a,
    input [3:0] b,
    input sel,
    output reg [3:0] out);always @(*) begin
        out = sel ? b : a;
    end

endmodule