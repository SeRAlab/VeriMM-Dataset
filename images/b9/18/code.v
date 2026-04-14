module digital_lock (
  input [3:0] code_input,
  input [3:0] correct_code,
  output reg unlock);
  
always @(*) begin
    if (code_input == correct_code)
        unlock = 1'b1;
    else
        unlock = 1'b0;
end
endmodule