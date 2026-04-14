module top_module(
  input clock,
  input reset,
  input [15:0] ex_alu_result,
  input [15:0] mem_read_data,
  input write_back_en,
  input [2:0] write_back_dest,
  input write_back_result_mux,
  output [36:0] RegMemToWBOut
);reg [36:0] RegMemToWB;
  always@(posedge clock) begin
    
    if(reset) begin
      RegMemToWB = 0;
    end
    else begin
           
      RegMemToWB[36:21] = ex_alu_result; 
      RegMemToWB[20:5] = mem_read_data;
      RegMemToWB[4:4] = write_back_en;
      RegMemToWB[3:1] = write_back_dest;
      RegMemToWB[0:0] = write_back_result_mux;
    end
  end
  
  assign RegMemToWBOut = RegMemToWB;
  
endmodule