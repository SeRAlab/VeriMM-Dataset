module shift_register(
    input               clk            ,   
    input               reset          ,
    input               load           ,
    input               shift_left     ,
    input               shift_right    ,
    input       [7:0]   parallel_data  ,
 
    output  reg [7:0]   q
);
    
   //8-bit Shift Register
   always @(posedge clk) begin
       if(reset) begin
          q <= 8'b00000000; // Reset to zero
       end
       else if(load) begin
          q <= parallel_data; // Load parallel data
       end
       else if(shift_left) begin
          q <= q << 1; // Shift left
       end
       else if(shift_right) begin
          q <= q >> 1; // Shift right
       end
   end
     
endmodule