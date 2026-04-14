module top_module(input_, VREF, Top_Pad_input, cbit_7);output input_;
    input VREF;
    input Top_Pad_input;
    input cbit_7;
assign input_ = (cbit_7)? Top_Pad_input : VREF;endmodule