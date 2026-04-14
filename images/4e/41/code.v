module top_module(
input wire [3:0] Valor_Decimal,
output reg [7:0] Code_7seg    
);always @*

begin

case(Valor_Decimal)

4'h0: Code_7seg = 8'b00000011; 
4'h1: Code_7seg = 8'b10011111; 
4'h2: Code_7seg = 8'b00100101; 
4'h3: Code_7seg = 8'b00001101; 
4'h4: Code_7seg = 8'b10011001; 
4'h5: Code_7seg = 8'b01001001; 
4'h6: Code_7seg = 8'b01000001; 
4'h7: Code_7seg = 8'b00011111; 
4'h8: Code_7seg = 8'b00000001; 
4'h9: Code_7seg = 8'b00001001; 
default: Code_7seg = 8'b11111111; 

endcase

end

endmodule