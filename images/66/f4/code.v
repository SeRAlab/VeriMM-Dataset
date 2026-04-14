module up_down_counter(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
    input               dir         ,
 
    output  reg [2:0]   count
);
    
   //count
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else if(enable) begin
          if (dir) begin
              count <= count + 1;
          end else begin
              count <= count - 1;
          end
       end
   end
     
endmodule