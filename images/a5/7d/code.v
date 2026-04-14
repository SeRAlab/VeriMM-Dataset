module top_module(
  input clk,
  input reset,
  input [3:0] data_in,
  output reg [3:0] encrypted_data
);reg [3:0] key = 4'b1010; // Fixed key value
  
  reg [3:0] adder_out; // Output of the ripple carry adder
  reg [3:0] shift_reg; // Shift register
  
  always @(posedge clk) begin
    if (reset) begin
      adder_out <= 4'b0;
      shift_reg <= 4'b0;
      encrypted_data <= 4'b0;
    end else begin
      // Add input data and key using ripple carry adder
      adder_out <= data_in + key;
      
      // Shift the output of the adder left by one bit
      shift_reg <= {adder_out[2:0], 1'b0};
      
      // Output the shifted data as encrypted data
      encrypted_data <= shift_reg;
    end
  end
  
endmodule