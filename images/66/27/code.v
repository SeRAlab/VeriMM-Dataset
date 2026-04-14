module top_module(
    input [3:0] data_in,
    output reg [1:0] data_out
);always @(*) begin
    data_out[0] = (data_in[0] & data_in[1]) | (~data_in[0] & ~data_in[1]); // Bitwise AND and OR
    data_out[1] = ((data_in[2] & data_in[3]) & data_out[0]) | (~data_in[2] & ~data_in[3] & ~data_out[0]); // Bitwise AND, OR, and NOT
end

endmodule