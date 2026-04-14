module top_module(
                     input clock,
                     input rst,
                     input semnal,                     
                     output pos_detected,
                     output neg_detected                     
                     );reg semnal_r0,semnal_r1;
                     always@(posedge clock)
                            if(~rst) begin
                                     semnal_r0 <=1'b0;
                                     semnal_r1<=1'b1;
                                   end
                                else begin
                                     semnal_r0 <= semnal;
                                     semnal_r1<= semnal_r0;
                                   end 
                     assign pos_detected  =  semnal_r0 & ~semnal_r1;
                     assign neg_detected  =   ~semnal_r0 & semnal_r1;  
                     
 endmodule