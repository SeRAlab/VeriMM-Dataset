module top_module(input wire clock,input wire ready,output wire [7:0] command_address,output wire [15:0] command_data,output reg command_valid,input wire [4:0] volume,input wire [2:0] source);reg [23:0] command; 
  reg [3:0] state; 
  initial begin 
  command <= 4'h0; 
  command_valid <= 1'b0; 
  state <= 16'h0000; 
  end 
  assign command_address = command[23:16]; 
  assign command_data = command[15:0]; 
  wire [4:0] vol; 
  assign vol = 31-volume; 
  always @(posedge clock) begin 
  if (ready) state <= state+1; 
  case (state) 
  4'h0: 
  begin 
  command <= 24'h80_0000; 
  command_valid <= 1'b1; 
  end 
  4'h1: 
  command <= 24'h80_0000; 
  4'h3: 
  command <= { 8'h04, 3'b000, vol, 3'b000, vol }; 
  4'h5: 
  command <= 24'h18_0808; 
  4'h6: 
  command <= { 8'h1A, 5'b00000, source, 5'b00000, source}; 
  4'h7: 
  command <= 24'h1C_0F0F; 
  4'h9: 
  command <= 24'h0E_8048; 
  4'hA: 
  command <= 24'h0A_0000; 
  4'hB: 
  command <= 24'h20_8000; 
  default: 
  command <= 24'h80_0000; 
  endcase 
  end 
 endmodule