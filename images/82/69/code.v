module top_module(output [31:0] O, input [31:0] DI, input CLK, WE, input [4:0] A, WA);parameter [31:0] INIT_00 = 32'h0; 
  parameter IS_WCLK_INVERTED = 1'b0; 
  reg [31:0] mem [0:31]; // Declare memory array of size 32
  initial mem[0] = INIT_00; // Initialize the first memory location
  assign O = mem[A]; 
  wire clk = CLK ^ IS_WCLK_INVERTED; 
  always @(posedge clk) 
    if (WE) begin 
      mem[WA] <= DI; 
    end 
endmodule