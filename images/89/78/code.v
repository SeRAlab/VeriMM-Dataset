module top_module( op_mode, Data_A, Data_B, Data_S, n3 );input [7:0] Data_A;
  input [7:0] Data_B;
  output [8:0] Data_S;
  output n3;
  input op_mode;
  
  wire [7:0] add_result;
  wire [7:0] sub_result;
  wire carry_out_add;
  wire carry_out_sub;

  // Addition operation
  assign {carry_out_add, add_result} = Data_A + Data_B;

  // Subtraction operation
  assign {carry_out_sub, sub_result} = Data_A - Data_B;

  // Carry-out signal based on op_mode
  assign n3 = ~op_mode;

  // Output signals, select between addition and subtraction
  assign Data_S = op_mode ? {carry_out_sub, sub_result} : {carry_out_add, add_result};

endmodule