module top_module(input wire clk,input wire reset_n,input wire cs,input wire we,input wire [7 : 0] address,input wire [31 : 0] write_data,output wire [31 : 0] read_data,output wire error,output wire csprng_debug_mode,output wire [4 : 0] csprng_num_rounds,output wire csprng_reseed,input wire csprng_error,output wire security_error);parameter ADDR_NAME0 = 8'h00; 
  parameter ADDR_NAME1 = 8'h01; 
  parameter ADDR_VERSION = 8'h02; 
  parameter CORE_NAME0 = 32'h73686132; 
  parameter CORE_NAME1 = 32'h2d323536; 
  parameter CORE_VERSION = 32'h302e3830; 
  reg [31 : 0] tmp_read_data; 
  reg tmp_error; 
  assign read_data = tmp_read_data; 
  assign error = tmp_error; 
  always @ (posedge clk) 
  begin 
  if (!reset_n) 
  begin 
  end 
  else 
  begin 
  end 
  end 
  always @* 
  begin : api_logic 
  tmp_read_data = 32'h00000000; 
  tmp_error = 0; 
  if (cs) 
  begin 
  if (we) 
  begin 
  case (address) 
  default: 
  begin 
  tmp_error = 1; 
  end 
  endcase 
  end 
  else 
  begin 
  case (address) 
  ADDR_NAME0: 
  begin 
  tmp_read_data = CORE_NAME0; 
  end 
  ADDR_NAME1: 
  begin 
  tmp_read_data = CORE_NAME1; 
  end 
  ADDR_VERSION: 
  begin 
  tmp_read_data = CORE_VERSION; 
  end 
  default: 
  begin 
  tmp_error = 1; 
  end 
  endcase 
  end 
  end 
  end 
 endmodule