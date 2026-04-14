module top_module(
  input [3:0] data,
  input clk,          // Added clk input
  output reg parity
);reg [1:0] stage1_data [0:1];
  reg [1:0] stage2_data [0:1];
  
  always @ (posedge clk) begin
    stage1_data[1] <= stage1_data[0];
    stage1_data[0] <= data[1:0]; // Changed to use only lower 2 bits
  end
  
  assign stage2_data[1] = stage1_data[1] ^ stage1_data[0];
  assign stage2_data[0] = 2'b00;
  
  always @ (posedge clk) begin
    parity <= stage2_data[1][0] ^ stage2_data[1][1];
  end
  
endmodule