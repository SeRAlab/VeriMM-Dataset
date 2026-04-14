module shift_register(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [15:0]  shift_out
);
    
   //16-bit Shift Register
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          shift_out <= 16'b0000000000000000; // Reset to zero
       end
       else if(enable) begin
          shift_out <= {shift_out[14:0], 1'b0}; // Shift left
       end
   end
     
endmodule