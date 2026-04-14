module top_module(
    // Inputs
    input A,
    input B,
    input C,
    input D,
    input [1:0] sel,

    // Outputs
    output reg out
);always @(*) begin
    case (sel)
        2'b00: out = A;
        2'b01: out = B;
        2'b10: out = C;
        2'b11: out = D;
        default: out = 1'b0;
    endcase
end

endmodule