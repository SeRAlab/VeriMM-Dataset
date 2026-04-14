module gray_counter(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [1:0]   gray
);
    
   //gray code counter
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          gray <= 2'b0;
       end
       else if(enable) begin
          gray <= {gray[1] ^ gray[0], gray[0] ^ 1'b1};
       end
   end
     
endmodule