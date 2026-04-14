module down_counter(
    input               clk         ,   
    input               rst         ,
 
    output  reg [15:0]  count
);
    
   //count logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 16'hFFFF;
       end
       else begin
          count <= count - 1;
       end
   end
     
endmodule