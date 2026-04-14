module two_bit_encoder (
    input [1:0] data,
    output reg q,
    output reg zero
);

    always @(*) begin
        q = data[1];
        zero = ~(|data);
    end

endmodule