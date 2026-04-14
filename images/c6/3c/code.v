module binary_to_gray (
    input [2:0] in,
    output reg [2:0] out
);

    always @(*) begin
        out[2] = in[2];
        out[1] = in[2] ^ in[1];
        out[0] = in[1] ^ in[0];
    end

endmodule