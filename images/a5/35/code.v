module johnson_counter(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [11:0]  johnson_out
);
    
   //12-bit Johnson Counter
   always @(posedge clk) begin
       if(rst) begin
          johnson_out <= 12'b000000000001; // Reset to initial state
       end
       else if(enable) begin
          johnson_out <= {~johnson_out[11], johnson_out[11:1]}; // Shift and invert MSB
       end
   end
     
endmodule