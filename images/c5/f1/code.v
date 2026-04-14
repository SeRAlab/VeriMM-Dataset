module xor_gate(
    input a,
    input b,
    output reg out
);

always @(*) begin
    out = a ^ b;
end

endmodule