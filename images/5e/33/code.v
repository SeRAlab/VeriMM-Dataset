module top_module(
  input clk, // Clock signal input 
  input rst_n, // Active low synchronous reset input 
  input [7:0] in_data, // 8-bit input data 
  output [7:0] out_data // 8-bit output data 
);reg [63:0] shift_reg; // 64-bit shift register 
  reg [2:0] counter; // 3-bit counter 

  // Shift register logic 
  always @(posedge clk) begin
    if (!rst_n) begin
      shift_reg <= 64'b0;
    end else begin
      shift_reg <= {shift_reg[62:0], in_data};
    end
  end

  // Counter logic 
  always @(posedge clk) begin
    if (!rst_n) begin
      counter <= 3'b0;
    end else begin
      counter <= counter + 1;
    end
  end

  // Functional module logic 
  assign out_data = shift_reg[7:0] & counter;

endmodule