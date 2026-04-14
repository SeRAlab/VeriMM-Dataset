module top_module(i_0r, i_0a, o_0r, o_0a, o_1r, o_1a, o_2r, o_2a, o_3r, o_3a, o_4r, o_4a, reset);input i_0r;
  output i_0a;
  output o_0r;
  input o_0a;
  output o_1r;
  input o_1a;
  output o_2r;
  input o_2a;
  output o_3r;
  input o_3a;
  output o_4r;
  input o_4a;
  input reset;
  
  wire [1:0] simp11_0;
  wire tech6_int;

  // Replace BUFEHD with a simple buffer
  assign o_0r = i_0r;
  assign o_1r = i_0r;
  assign o_2r = i_0r;
  assign o_3r = i_0r;
  assign o_4r = i_0r;

  // Replace AO222EHD with a simple logic gate or behavioral code.
  // Example: basic AND logic for 2 inputs, you may need to adjust logic.
  assign tech6_int = (o_0a & o_1a) | (o_0a & tech6_int) | (o_1a & tech6_int);

  assign simp11_0[0] = (tech6_int & o_2a) | (tech6_int & simp11_0[0]) | (o_2a & simp11_0[0]);
  assign simp11_0[1] = (o_3a & o_4a) | (o_3a & simp11_0[1]) | (o_4a & simp11_0[1]);

  assign i_0a = (simp11_0[0] & simp11_0[1]) | (simp11_0[0] & i_0a) | (simp11_0[1] & i_0a);
endmodule