module sync_load_register(
    input               clk         ,   
    input               rst         ,
    input               load        ,
    input       [3:0]   data_in     ,
 
    output  reg [3:0]   data_out
);
    
   //data_out logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          data_out <= 0;
       end
       else if(load) begin
          data_out <= data_in;
       end
   end
     
endmodule