module top_module(
  input [3:0] input1,
  input [3:0] input2,
  input single_bit_input,
  output reg [3:0] output_signal
);always @(*) begin
    if (single_bit_input == 0) begin
      output_signal = input1;
    end
    else begin
      output_signal = input2;
    end
  end
  
  always @(*) begin
    if (input1 == input2) begin
      output_signal = input1;
    end
    else begin
      output_signal = input1 & input2;
    end
  end

endmodule