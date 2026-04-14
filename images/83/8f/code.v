module enable_counter(
    input               clk         ,   
    input               rst         ,
    input               en          ,
 
    output  reg [9:0]   count
);
    
   //count logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else if(en) begin
          count <= count + 1;
       end
   end
     
endmodule