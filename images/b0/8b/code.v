module top_module(
                 input clk, 
                 input reset,
                 input [15:0] t,
                 output reg [4:0] eta   
    );reg [4:0] eta_reg; 
    reg [4:0] eta_start;
    reg [4:0] eta_d; 
   
   
          
   always @(posedge clk) begin
       if(t[15] == 1) begin 
           eta_start <= t[14:13]*3;
       end
       else if(t[15] == 0) begin 
           eta_start <= (5'b00100 + t[14:13])*3;
       end
       
       if(t[12:0] < 13'b0101010101010) begin 
           eta_reg <= 5'b00000;
       end
       else if(t[12:0] < 13'b1010101010100) begin 
           eta_reg <= 5'b00001;
       end
       else begin 
           eta_reg <= 5'b00010;
       end

        eta_d <= eta_start + eta_reg;
        eta <= eta_d;
   end
endmodule