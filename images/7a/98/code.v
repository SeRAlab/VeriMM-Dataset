module shift_register(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [7:0]   data_out
);
    
   //shift register
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          data_out <= 8'b0;
       end
       else if(enable) begin
          data_out <= data_out << 1;
       end
   end
     
endmodule