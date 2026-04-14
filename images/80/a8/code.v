module top_module(
  clk,rst,input_sig,output_sig
    );input clk,rst;
   input input_sig;
   output wire output_sig;
   
   reg [1:0] rinput;
   
   
   always @(posedge clk, posedge rst)
   begin 
    if(rst) begin  rinput<=0; end 
    else begin
      rinput[1]<=rinput[0];
      rinput[0]<=input_sig;
    end 
   end

  assign output_sig=(~rinput[1]&&rinput[0])?1:0;
  
endmodule