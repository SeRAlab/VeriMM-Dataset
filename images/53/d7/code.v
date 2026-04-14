module top_module(
    input [3:0] data_in,
    output reg [3:0] excess_3_out
);always @(*) begin
        excess_3_out[0] = data_in[0] ^ 1'b1 ^ 1'b1 ^ 1'b1;
        excess_3_out[1] = data_in[1] ^ 1'b1 ^ 1'b1 ^ 1'b0;
        excess_3_out[2] = data_in[2] ^ 1'b1 ^ 1'b0 ^ 1'b1;
        excess_3_out[3] = data_in[3] ^ 1'b1 ^ 1'b0 ^ 1'b0;
    end

endmodule