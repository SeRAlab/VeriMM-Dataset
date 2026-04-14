module top_module(
  input [4:0] binary,
  input dir,
  output [4:0] gray,
  output [4:0] rotated
);wire [4:0] gray_pipe1;
  wire [4:0] gray_pipe2;
  wire [4:0] gray_pipe3;
  wire [4:0] gray_pipe4;
  wire [4:0] gray_pipe5;
  wire [4:0] gray_pipe6;

  assign gray_pipe1[0] = binary[0];
  assign gray_pipe1[1] = binary[0] ^ binary[1];
  assign gray_pipe1[2] = binary[1] ^ binary[2];
  assign gray_pipe1[3] = binary[2] ^ binary[3];
  assign gray_pipe1[4] = binary[3] ^ binary[4];

  assign gray_pipe2[0] = gray_pipe1[0];
  assign gray_pipe2[1] = gray_pipe1[1];
  assign gray_pipe2[2] = gray_pipe1[1] ^ gray_pipe1[2];
  assign gray_pipe2[3] = gray_pipe1[2] ^ gray_pipe1[3];
  assign gray_pipe2[4] = gray_pipe1[3] ^ gray_pipe1[4];

  assign gray_pipe3[0] = gray_pipe2[0];
  assign gray_pipe3[1] = gray_pipe2[1];
  assign gray_pipe3[2] = gray_pipe2[2];
  assign gray_pipe3[3] = gray_pipe2[2] ^ gray_pipe2[3];
  assign gray_pipe3[4] = gray_pipe2[3] ^ gray_pipe2[4];

  assign gray_pipe4[0] = gray_pipe3[0];
  assign gray_pipe4[1] = gray_pipe3[1];
  assign gray_pipe4[2] = gray_pipe3[2];
  assign gray_pipe4[3] = gray_pipe3[3];
  assign gray_pipe4[4] = gray_pipe3[3] ^ gray_pipe3[4];

  assign gray_pipe5[0] = gray_pipe4[0];
  assign gray_pipe5[1] = gray_pipe4[1];
  assign gray_pipe5[2] = gray_pipe4[2];
  assign gray_pipe5[3] = gray_pipe4[3];
  assign gray_pipe5[4] = gray_pipe4[4];

  assign gray_pipe6[0] = gray_pipe5[0];
  assign gray_pipe6[1] = gray_pipe5[1];
  assign gray_pipe6[2] = gray_pipe5[2];
  assign gray_pipe6[3] = gray_pipe5[3];
  assign gray_pipe6[4] = gray_pipe5[4];

  assign gray = gray_pipe6;

  assign rotated = (dir == 1'b0) ? {gray[3:0], gray[4]} : {gray[0], gray[4:1]};

endmodule