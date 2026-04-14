module top_module(
  input [9:0] Vin, // analog input voltage
  input clk, // clock signal
  output reg [7:0] Dout // digital output
);reg [7:0] ref_voltages; // reference voltages
  reg [7:0] comparator_outputs; // comparator outputs
  
  always @(*) begin
    ref_voltages = {8{Vin[9:2]}} + {8{1'b0}}; // evenly spaced reference voltages
    comparator_outputs = {Vin[1:0], Vin[1:0], Vin[1:0], Vin[1:0], Vin[1:0], Vin[1:0], Vin[1:0], Vin[1:0]} > ref_voltages; // comparator outputs
    Dout = comparator_outputs; // digital output
  end
  
  always @(posedge clk) begin
    Dout <= comparator_outputs; // sample input voltage on rising edge of clock signal
  end
  
endmodule