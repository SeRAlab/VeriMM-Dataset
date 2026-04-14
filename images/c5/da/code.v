module bitwise_operation(
    input [7:0] a_in,
    input [7:0] b_in,
    output reg [7:0] out
);

    always @(*) begin
        out[0] = a_in[0] ^ b_in[0];
        out[1] = ~(a_in[1] ^ b_in[1]);
        out[2:7] = a_in[2:7];
    end

endmodule