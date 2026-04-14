module register_16bit(
    input               clk            ,   
    input               reset          ,
    input               load           ,
    input               clear          ,
    input       [15:0]  parallel_data  ,
 
    output  reg [15:0]  q
);
    
   //16-bit Register
   always @(posedge clk) begin
       if(reset) begin
          q <= 16'b0000000000000000; // Reset to zero
       end
       else if(clear) begin
          q <= 16'b0000000000000000; // Clear to zero
       end
       else if(load) begin
          q <= parallel_data; // Load parallel data
       end
   end
     
endmodule