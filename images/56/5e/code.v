module top_module(
  input clock,
  input reset,
  input [15:0] ex_alu_result,
  input mem_write_en,
  input[15:0] mem_write_data,
  input write_back_en,
  input [2:0] write_back_dest,
  input write_back_result_mux,
  output [37:0] RegExToMemOut
);reg [37:0]myRegExToMem;
  always@(posedge clock) begin
    if(reset) begin
      myRegExToMem = 0;
    end
    else begin
      
      myRegExToMem[37:22] = ex_alu_result; 
      myRegExToMem[21:21] = mem_write_en;
      myRegExToMem[20:5] = mem_write_data;
      myRegExToMem[4:4] = write_back_en;
      myRegExToMem[3:1] = write_back_dest;
      myRegExToMem[0:0] = write_back_result_mux;
    end
  end
  
  assign RegExToMemOut = myRegExToMem;
  
  
endmodule