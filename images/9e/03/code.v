module mux_2to1(
    input               sel         ,   
    input       [3:0]   a           ,
    input       [3:0]   b           ,
 
    output  reg [3:0]   y
);
    
   //mux logic
   always @(*) begin
       if(sel) begin
          y = b;
       end
       else begin
          y = a;
       end
   end
     
endmodule