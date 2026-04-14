module top_module(
  input       clk,
  input       rst,
  input      [2:0] decoding_op_src1,
  input      [2:0] decoding_op_src2,
  input      [2:0] decoding_op_dest,
  input      [2:0] ex_op_dest,
  input      [2:0] mem_op_dest,
  input      [2:0] wb_op_dest,
  output reg   pipeline_stall_n
);always@(*) begin
      pipeline_stall_n = 1;
      
    if(rst) begin
      pipeline_stall_n = 0;
    end
    else if((decoding_op_src1 == wb_op_dest || decoding_op_src1 == mem_op_dest || decoding_op_src1 == ex_op_dest) && (decoding_op_src1 != 0) )
      pipeline_stall_n = 0;
  
    else if((decoding_op_src2 == wb_op_dest || decoding_op_src2 == mem_op_dest || decoding_op_src2 == ex_op_dest) && (decoding_op_src2 != 0) )
      pipeline_stall_n = 0;
      
    else if((decoding_op_dest == wb_op_dest || decoding_op_dest == mem_op_dest || decoding_op_dest == ex_op_dest) && (decoding_op_dest != 0) )
      pipeline_stall_n = 0;
  end
     
endmodule