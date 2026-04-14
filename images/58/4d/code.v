module top_module(output O, input I0, I1, I2, I3, S0, S1);assign O = S1 ? (S0 ? I3 : I2)
                : (S0 ? I1 : I0);
  specify
    (I0 => O) = 294;
    (I1 => O) = 297;
    (I2 => O) = 311;
    (I3 => O) = 317;
    (S0 => O) = 390;
    (S1 => O) = 273;
  endspecify
endmodule