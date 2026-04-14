module top_module(I, S, O);input [11:0] I;
  input [3:0] S;
  output O;
  
  reg [11:0] select_signals [0:11];
  reg [11:0] selected_input;
  
  // Generate select signals using a decoder
  always @(*) begin
    case (S)
      4'b0000: select_signals[0] = I;
      4'b0001: select_signals[1] = I;
      4'b0010: select_signals[2] = I;
      4'b0011: select_signals[3] = I;
      4'b0100: select_signals[4] = I;
      4'b0101: select_signals[5] = I;
      4'b0110: select_signals[6] = I;
      4'b0111: select_signals[7] = I;
      4'b1000: select_signals[8] = I;
      4'b1001: select_signals[9] = I;
      4'b1010: select_signals[10] = I;
      4'b1011: select_signals[11] = I;
    endcase
  end
  
  // Select the appropriate input signal based on S
  always @(*) begin
    if (S == 4'b0000) selected_input = select_signals[0];
    else if (S == 4'b0001) selected_input = select_signals[1];
    else if (S == 4'b0010) selected_input = select_signals[2];
    else if (S == 4'b0011) selected_input = select_signals[3];
    else if (S == 4'b0100) selected_input = select_signals[4];
    else if (S == 4'b0101) selected_input = select_signals[5];
    else if (S == 4'b0110) selected_input = select_signals[6];
    else if (S == 4'b0111) selected_input = select_signals[7];
    else if (S == 4'b1000) selected_input = select_signals[8];
    else if (S == 4'b1001) selected_input = select_signals[9];
    else if (S == 4'b1010) selected_input = select_signals[10];
    else if (S == 4'b1011) selected_input = select_signals[11];
  end
  
  // Assign the selected input signal to the output
  assign O = selected_input[0];
  
endmodule