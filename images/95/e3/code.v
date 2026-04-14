module binary_counter_sync(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [3:0]   count
);
    
   //count logic
   always @(posedge clk) begin
       if(rst) begin
          count <= 0;
       end
       else if(enable) begin
          count <= count + 1;
       end
   end
     
endmodule