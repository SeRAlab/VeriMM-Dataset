module binary_counter(
    input               clk         ,   
    input               rst         ,
 
    output  reg [3:0]   count
);
    
   //count logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else begin
          count <= count + 1;
       end
   end
     
endmodule