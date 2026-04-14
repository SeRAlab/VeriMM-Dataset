module piso_shift_register(
    input               clk         ,   
    input               enable      ,
    input               load        ,
    input       [7:0]   parallel_in ,
 
    output  reg         serial_out
);
    reg [7:0] shift_reg;

   //8-bit PISO Shift Register
   always @(posedge clk) begin
       if(load) begin
          shift_reg <= parallel_in; // Load parallel data
       end
       else if(enable) begin
          shift_reg <= {1'b0, shift_reg[7:1]}; // Shift right
       end
       serial_out <= shift_reg[0];
   end
     
endmodule