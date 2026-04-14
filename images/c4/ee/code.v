module little_endian (data_in, clk, data_out);
input [7:0] data_in;
input clk;
output reg [7:0] data_out;

always @(posedge clk) begin
    data_out[0] = data_in[7];
    data_out[1] = data_in[6];
    data_out[2] = data_in[5];
    data_out[3] = data_in[4];
    data_out[4] = data_in[3];
    data_out[5] = data_in[2];
    data_out[6] = data_in[1];
    data_out[7] = data_in[0];
end

endmodule