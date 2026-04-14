module top_module(
  output reg [0:3] DISPn,
  output reg [0:6] HEX,
  input wire [0:6] HEX0,
  input wire [0:6] HEX1,
  input wire [0:6] HEX2,
  input wire [0:6] HEX3,
  input wire clk 
);parameter 
  state0 = 2'b00, 
  state1 = 2'b01, 
  state2 = 2'b10, 
  state3 = 2'b11;
 
  reg [1:0] state;
  reg [1:0] nextstate;

   always @* begin
     nextstate = state; 
     case (state) 
        state0: nextstate = state1;
        state1: nextstate = state2;
        state2: nextstate = state3;
        state3: nextstate = state0;	
     endcase
  end

   always @(posedge clk) begin
       state <= nextstate;
   end

   always @(posedge clk) begin
   begin
     case (nextstate)
       state1: begin
         DISPn[0:3] <= "1110";
         HEX[0:6] <=  HEX0[0:6];
       end  
       state1: begin
         DISPn[0:3] <= "1101";
         HEX[0:6] <=  HEX1[0:6];
       end
       state2: begin
         DISPn[3:3] <= "1011";
         HEX[0:6] <=  HEX2[0:6];
       end
       state3: begin
         DISPn[0:3] <= "0111";
         HEX[0:6] <=  HEX3[0:6];
       end
     endcase
   end
end
endmodule