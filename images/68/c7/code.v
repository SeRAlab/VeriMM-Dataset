module top_module(input [3:0] Codigo_D, output reg [7:0] catodo2);always @(*) 
  begin 
    case (Codigo_D) 
      4'h0: begin 
        catodo2 <= 8'b00000011; 
      end 
      4'h1: begin 
        catodo2 <= 8'b10011111; 
      end 
      4'h2: begin 
        catodo2 <= 8'b00100101; 
      end 
      4'h3: begin 
        catodo2 <= 8'b00001101; 
      end 
      4'h4: begin 
        catodo2 <= 8'b10011001; 
      end 
      4'h5: begin 
        catodo2 <= 8'b01001001; 
      end 
      4'h6: begin 
        catodo2 <= 8'b01000001; 
      end 
      4'h7: begin 
        catodo2 <= 8'b00011111; 
      end 
      4'h8: begin 
        catodo2 <= 8'b00000001; 
      end 
      4'h9: begin 
        catodo2 <= 8'b00011001; 
      end 
      4'hA: begin 
        catodo2 <= 8'b10011001; 
      end 
      4'hB: begin 
        catodo2 <= 8'b01001001; // fixed the value with the correct number of bits
      end 
      4'hC: begin 
        catodo2 <= 8'b01000001; 
      end 
      4'hD: begin 
        catodo2 <= 8'b00011111; 
      end 
      4'hE: begin 
        catodo2 <= 8'b00000001; 
      end 
      4'hF: begin 
        catodo2 <= 8'b00011001; 
      end 
      default: begin 
        catodo2 <= 8'b10011111; 
      end 
    endcase 
  end 
endmodule