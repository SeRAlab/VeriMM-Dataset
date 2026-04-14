module lfsr(
    input               clk         ,   
    input               rst         ,
    input               enable      ,
 
    output  reg [5:0]   lfsr_out
);
    
   //Linear Feedback Shift Register
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          lfsr_out <= 6'b000001; // Seed value
       end
       else if(enable) begin
          lfsr_out <= {lfsr_out[4:0], lfsr_out[5] ^ lfsr_out[3]};
       end
   end
     
endmodule