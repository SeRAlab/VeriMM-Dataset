module xor_module (
    input a,
    input b,
    input reset,
    output reg result
);

    always @(*) begin
        if (reset) begin
            result = 0;
        end else begin
            result = a ^ b;
        end
    end
endmodule