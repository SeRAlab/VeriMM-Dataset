module load_register(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
    input       [7:0]   data_in     ,
 
    output  reg [7:0]   data_out
);
    
   //data_out
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          data_out <= 0;
       end
       else if(enable) begin
          data_out <= data_in;
       end
   end
     
endmodule