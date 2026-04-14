module top_module(
   input [3:0] binary,
   output reg [3:0] hex
   );always @(*) begin
      case (binary)
         4'd0: hex = 4'h0;
         4'd1: hex = 4'h1;
         4'd2: hex = 4'h2;
         4'd3: hex = 4'h3;
         4'd4: hex = 4'h4;
         4'd5: hex = 4'h5;
         4'd6: hex = 4'h6;
         4'd7: hex = 4'h7;
         4'd8: hex = 4'h8;
         4'd9: hex = 4'h9;
         4'd10: hex = 4'hA;
         4'd11: hex = 4'hB;
         4'd12: hex = 4'hC;
         4'd13: hex = 4'hD;
         4'd14: hex = 4'hE;
         4'd15: hex = 4'hF;
         default: hex = 4'hX;
      endcase
   end

endmodule