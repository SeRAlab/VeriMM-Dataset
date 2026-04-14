module loadable_counter(
    input               clk         ,   
    input               rst         ,
    input               load        ,
    input [11:0]        load_value  ,
 
    output  reg [11:0]  count
);
    
   //count logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else if(load) begin
          count <= load_value;
       end
       else begin
          count <= count + 1;
       end
   end
     
endmodule