module top_module(Data_i,
    Round_Type_i,
    Sign_Result_i,
    Round_Flag_o);input [1:0] Data_i;
  input [1:0] Round_Type_i;
  input Sign_Result_i;
  output Round_Flag_o;

  wire [1:0] Data_i;
  wire Round_Flag_o;
  wire [1:0] Round_Type_i;
  wire Sign_Result_i;

  // Using a combinational logic block to replace LUT5 since it is missing
  assign Round_Flag_o = (Round_Type_i[0] && Data_i[0] && !Sign_Result_i) || 
                        (Round_Type_i[1] && !Data_i[1] && Sign_Result_i) || 
                        (Round_Type_i[0] && Data_i[1] && Sign_Result_i) || 
                        (!Round_Type_i[1] && !Data_i[0] && !Sign_Result_i);

endmodule