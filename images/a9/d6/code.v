module top_module(
  ps2_clk_rx_1,     // O
  ps2_clk_rx_2,     // O
  ps2_clk_tx_1,     // I
  ps2_clk_tx_2,     // I
  ps2_d_rx_1,       // O
  ps2_d_rx_2,       // O
  ps2_d_tx_1,       // I
  ps2_d_tx_2,       // I
  ps2_mouse_clk_I,  // I
  ps2_mouse_clk_O,  // O
  ps2_mouse_clk_T,  // O
  ps2_mouse_data_I, // I
  ps2_mouse_data_O, // O
  ps2_mouse_data_T, // O
  ps2_keyb_clk_I,   // I
  ps2_keyb_clk_O,   // O
  ps2_keyb_clk_T,   // O
  ps2_keyb_data_I,  // I
  ps2_keyb_data_O,  // O
  ps2_keyb_data_T   // O
  );output ps2_clk_rx_1;
  output ps2_clk_rx_2;
  input  ps2_clk_tx_1;
  input  ps2_clk_tx_2;
  output ps2_d_rx_1;
  output ps2_d_rx_2;
  input  ps2_d_tx_1;
  input  ps2_d_tx_2;
  input  ps2_mouse_clk_I;
  output ps2_mouse_clk_O;
  output ps2_mouse_clk_T;
  input  ps2_mouse_data_I;
  output ps2_mouse_data_O;
  output ps2_mouse_data_T;
  input  ps2_keyb_clk_I;
  output ps2_keyb_clk_O;
  output ps2_keyb_clk_T;
  input  ps2_keyb_data_I;
  output ps2_keyb_data_O;
  output ps2_keyb_data_T;

  // PS/2 Assignments
  assign ps2_clk_rx_1 = ps2_mouse_clk_I;
  assign ps2_clk_rx_2 = ps2_keyb_clk_I;
  assign ps2_d_rx_1   = ps2_mouse_data_I;
  assign ps2_d_rx_2   = ps2_keyb_data_I;

  assign ps2_mouse_clk_O  = 1'b0;
  assign ps2_mouse_clk_T  = ~ps2_clk_tx_1;
  assign ps2_mouse_data_O = 1'b0;
  assign ps2_mouse_data_T = ~ps2_d_tx_1;
  assign ps2_keyb_clk_O   = 1'b0;
  assign ps2_keyb_clk_T   = ~ps2_clk_tx_2;
  assign ps2_keyb_data_O  = 1'b0;
  assign ps2_keyb_data_T  = ~ps2_d_tx_2;

endmodule