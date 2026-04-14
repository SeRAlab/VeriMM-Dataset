module top_module(
  input subsig1,
  input subsig2,
  output subout
);// If subsig1 is 1 and subsig2 is 0, set subout to 1
  assign subout = (subsig1 == 1 && subsig2 == 0) ? 1 :
                  // If subsig1 is 0 and subsig2 is 1, set subout to 0
                  (subsig1 == 0 && subsig2 == 1) ? 0 :
                  // If both subsig1 and subsig2 are 1, set subout to 0
                  (subsig1 == 1 && subsig2 == 1) ? 0 :
                  // If both subsig1 and subsig2 are 0, set subout to 1
                  1;
endmodule