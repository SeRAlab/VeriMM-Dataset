module bin_counter(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [3:0]   count
);
    
   //count
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else if(enable) begin
          count <= count + 1;
       end
   end
     
endmodule