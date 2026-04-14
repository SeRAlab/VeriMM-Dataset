module top_module(
  input [3:0] data,
  input [1:0] ctrl,
  output [6:0] seg
);// Define the 7-bit segment signal as a Boolean function of the 4-bit data signal and the 2-bit control signal
  assign seg[0] = (data[0] & ctrl[0]) | (~data[0] & ctrl[1]);
  assign seg[1] = (data[1] & ctrl[0]) | (~data[1] & ctrl[1]);
  assign seg[2] = (data[2] & ctrl[0]) | (~data[2] & ctrl[1]);
  assign seg[3] = (data[3] & ctrl[0]) | (~data[3] & ctrl[1]);
  assign seg[4] = ctrl[0];
  assign seg[5] = ctrl[1];
  assign seg[6] = 0;

endmodule