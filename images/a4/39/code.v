module top_module(
  input ctrl,
  input [7:0] data,
  output reg [7:0] resistance // Change output to reg type
);reg [7:0] resistor_values = 8'b00000001; // initialize with first resistor enabled
  
  always @ (ctrl or data) begin
    case(ctrl)
      3'b000: resistor_values[0] = data[0]; // enable/disable first resistor based on data bit 0
      3'b001: resistor_values[1] = data[1]; // enable/disable second resistor based on data bit 1
      3'b010: resistor_values[2] = data[2]; // enable/disable third resistor based on data bit 2
      3'b011: resistor_values[3] = data[3]; // enable/disable fourth resistor based on data bit 3
      3'b100: resistor_values[4] = data[4]; // enable/disable fifth resistor based on data bit 4
      3'b101: resistor_values[5] = data[5]; // enable/disable sixth resistor based on data bit 5
      3'b110: resistor_values[6] = data[6]; // enable/disable seventh resistor based on data bit 6
      3'b111: resistor_values[7] = data[7]; // enable/disable eighth resistor based on data bit 7
    endcase
    
    resistance = resistor_values; // Assign resistor_values directly to resistance
  end

endmodule