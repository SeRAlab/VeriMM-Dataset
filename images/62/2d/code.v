module top_module(
    input [7:0] data_in,
    output reg [7:0] gray_out
);always @(*) begin
        gray_out[0] = data_in[0];
        gray_out[1] = data_in[0] ^ data_in[1];
        gray_out[2] = data_in[1] ^ data_in[2];
        gray_out[3] = data_in[2] ^ data_in[3];
        gray_out[4] = data_in[3] ^ data_in[4];
        gray_out[5] = data_in[4] ^ data_in[5];
        gray_out[6] = data_in[5] ^ data_in[6];
        gray_out[7] = data_in[6] ^ data_in[7];
    end

endmodule