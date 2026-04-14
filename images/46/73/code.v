module top_module(output O, input I0, I1, S);assign O = S ? I1 : I0;
  specify
    
    (I0 => O) = 104;
    (I1 => O) = 94;
    (S => O) = 273;
  endspecify
endmodule