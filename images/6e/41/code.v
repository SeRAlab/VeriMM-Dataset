module top_module(din, dout);input [14:0] din;
output [3:0] dout;

wire [14:0] onehot;

genvar i;
generate
  for (i = 0; i < 15; i = i + 1) begin
    assign onehot[i] = din[i] & ~(|din[i+1:0]);
  end
endgenerate

assign dout[3] = |onehot[14:7];
assign dout[2] = (|onehot[6:3]) | (|onehot[14:11]);
assign dout[1] = (|onehot[2:1]) | (|onehot[6:5]) | (|onehot[10:9]) | (|onehot[14:13]);
assign dout[0] = onehot[0] | onehot[2] | onehot[4] | onehot[6] | onehot[8] | onehot[10] | onehot[12] | onehot[14];

endmodule