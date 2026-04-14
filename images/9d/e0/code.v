module top_module(
  input clock,
  input reset,
  input[3:0] ex_alu_cmd,
  input [15:0] ex_alu_src1,
  input[15:0] ex_alu_src2,
  input mem_write_en,
  input [15:0] mem_write_data,
  input write_back_en,
  input [2:0] write_back_dest,
  input write_back_result_mux,
  input stall,
  output [57:0] RegIDToExOut
);reg [57:0]myRegIDToEx;
  always@(posedge clock) begin
    if(reset)
      myRegIDToEx = 0;
    else if(stall) begin 
      myRegIDToEx[57:54] = ex_alu_cmd; 
      myRegIDToEx[53:38] = ex_alu_src1;
      myRegIDToEx[37:22] = ex_alu_src2;
      myRegIDToEx[21:21] = mem_write_en;
      myRegIDToEx[20:5] = mem_write_data;
      myRegIDToEx[4:4] = write_back_en;
      myRegIDToEx[3:1] = write_back_dest;
      myRegIDToEx[0:0] = write_back_result_mux;
    end
    else
      myRegIDToEx = 0;
   end
  
  assign RegIDToExOut = myRegIDToEx;
  
endmodule