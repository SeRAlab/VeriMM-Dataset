module little_endian(
    input [3:0] data_in,
    output reg [1:0] data_out
);

    always @(*) begin
        data_out[1] = data_in[2];
        data_out[0] = data_in[3];
    end

endmodule