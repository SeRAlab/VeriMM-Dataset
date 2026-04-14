module top_module(
  input [13:1] one_hot_regime,
  output [3:0] regime_bin);assign regime_bin[0] = |({one_hot_regime[1], one_hot_regime[3], one_hot_regime[5], one_hot_regime[7], one_hot_regime[9], one_hot_regime[11], one_hot_regime[13]});
  assign regime_bin[1] = |({one_hot_regime[2], one_hot_regime[3], one_hot_regime[6], one_hot_regime[7], one_hot_regime[10], one_hot_regime[11]});
  assign regime_bin[2] = |({one_hot_regime[4], one_hot_regime[5], one_hot_regime[6], one_hot_regime[7], one_hot_regime[12], one_hot_regime[13]});
  assign regime_bin[3] = |({one_hot_regime[8], one_hot_regime[9], one_hot_regime[10], one_hot_regime[11], one_hot_regime[12], one_hot_regime[13]});endmodule