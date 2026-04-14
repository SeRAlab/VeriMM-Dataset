module xor_gate(
    input a,
    input b,
    output reg out_if_else
);

always @(*) begin
    if(a != b) begin
        out_if_else = 1;
    end
    else begin
        out_if_else = 0;
    end
end

endmodule