module top_module(I, S, O);input [11:0] I;
  input [3:0] S;
  output O;

  wire [11:0] MuxOut; // MuxOut should have 12 bits

  assign MuxOut[0] = (S == 4'b0000) ? I[0] : 1'b0;
  assign MuxOut[1] = (S == 4'b0001) ? I[0] : 1'b0;
  assign MuxOut[2] = (S == 4'b0010) ? I[0] : 1'b0;
  assign MuxOut[3] = (S == 4'b0011) ? I[0] : 1'b0;
  assign MuxOut[4] = (S == 4'b0100) ? I[1] : 1'b0;
  assign MuxOut[5] = (S == 4'b0101) ? I[1] : 1'b0;
  assign MuxOut[6] = (S == 4'b0110) ? I[1] : 1'b0;
  assign MuxOut[7] = (S == 4'b0111) ? I[1] : 1'b0;
  assign MuxOut[8] = (S == 4'b1000) ? I[2] : 1'b0;
  assign MuxOut[9] = (S == 4'b1001) ? I[2] : 1'b0;
  assign MuxOut[10] = (S == 4'b1010) ? I[2] : 1'b0;
  assign MuxOut[11] = (S == 4'b1011) ? I[2] : 1'b0;

  assign O = MuxOut[0] | MuxOut[1] | MuxOut[2] | MuxOut[3] | MuxOut[4] | MuxOut[5] | MuxOut[6] | MuxOut[7] | MuxOut[8] | MuxOut[9] | MuxOut[10] | MuxOut[11];

endmodule