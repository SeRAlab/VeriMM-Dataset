module up_down_counter(
    input               clk         ,   
    input               rst         ,
    input               up          ,
    input               down        ,
 
    output  reg [15:0]  count
);
    
   //count logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else if(up) begin
          count <= count + 1;
       end
       else if(down) begin
          count <= count - 1;
       end
   end
     
endmodule