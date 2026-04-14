module top_module(
  input [3:0] control_signals,
  input [3:0] input_data,
  output reg [3:0] output_data
);wire [3:0] adder_output;
  wire [2:0] encoder_output;

  // 4-bit adder
  assign adder_output = (control_signals[2:0] == 3'b000) ? input_data + 4'b0000 : 
                        (control_signals[2:0] == 3'b001) ? input_data + 4'b0001 :
                        (control_signals[2:0] == 3'b010) ? input_data + 4'b0010 :
                        4'b0000;

  // Priority encoder
  assign encoder_output = (control_signals[2:0] == 3'b011) ? {3'b000, input_data[3]} :
                          (control_signals[2:0] == 3'b100) ? {3'b001, input_data[2]} :
                          (control_signals[2:0] == 3'b101) ? {3'b010, input_data[1]} :
                          3'b000;

  // Output selection
  always @(*) begin
    case(control_signals)
      3'b000, 3'b001, 3'b010: output_data = adder_output;
      3'b011, 3'b100, 3'b101: output_data = encoder_output;
      default: output_data = 4'b0000;
    endcase
  end

endmodule