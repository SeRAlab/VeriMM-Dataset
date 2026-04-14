module shift_register(
    input               clk         ,   
    input               rst         ,
    input               load        ,
    input               shift       ,
    input       [7:0]   data_in     ,
 
    output  reg [7:0]   data_out
);
    
   //data_out
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          data_out <= 0;
       end
       else if(load) begin
          data_out <= data_in;
       end
       else if(shift) begin
          data_out <= data_out << 1;
       end
       else begin
          data_out <= data_out >> 1;
       end
   end
     
endmodule