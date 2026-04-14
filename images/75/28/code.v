module top_module(input [19:0] io_input_PADDR,input [0:0] io_input_PSEL,input io_input_PENABLE,output io_input_PREADY,input io_input_PWRITE,input [31:0] io_input_PWDATA,output [31:0] io_input_PRDATA,output io_input_PSLVERROR,output [19:0] io_output_PADDR,output reg [2:0] io_output_PSEL,output io_output_PENABLE,input io_output_PREADY,output io_output_PWRITE,output [31:0] io_output_PWDATA,input [31:0] io_output_PRDATA,input io_output_PSLVERROR);wire [19:0] _zz_1; 
  wire [19:0] _zz_2; 
  wire [19:0] _zz_3; 
  assign _zz_1 = (20'b11111111000000000000); 
  assign _zz_2 = (20'b11111111000000000000); 
  assign _zz_3 = (20'b11111111000000000000); 
  assign io_output_PADDR = io_input_PADDR; 
  assign io_output_PENABLE = io_input_PENABLE; 
  assign io_output_PWRITE = io_input_PWRITE; 
  assign io_output_PWDATA = io_input_PWDATA; 
  always @ (*) begin 
  io_output_PSEL[0] = (((io_input_PADDR & _zz_1) == (20'b00000000000000000000)) && io_input_PSEL[0]); 
  io_output_PSEL[1] = (((io_input_PADDR & _zz_2) == (20'b00010000000000000000)) && io_input_PSEL[0]); 
  io_output_PSEL[2] = (((io_input_PADDR & _zz_3) == (20'b00100000000000000000)) && io_input_PSEL[0]); 
  end 
  assign io_input_PREADY = io_output_PREADY; 
  assign io_input_PRDATA = io_output_PRDATA; 
  assign io_input_PSLVERROR = io_output_PSLVERROR; 
 endmodule