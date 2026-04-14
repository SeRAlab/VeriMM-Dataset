module johnson_counter(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [4:0]   count
);
    
   //Johnson counter
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 5'b0;
       end
       else if(enable) begin
          count <= {~count[0], count[4:1]};
       end
   end
     
endmodule