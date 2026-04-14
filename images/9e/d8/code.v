module binary_and_gate (
    input [2:0] u,
    input [2:0] v,
    output reg [2:0] and_out);always @(*) begin
        and_out = u & v;
    end

endmodule