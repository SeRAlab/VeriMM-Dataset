module top_module(
   input wire       enable,
   input wire [1:0] Data_i,
   output reg [2:0] Data_o
   );always @(*) begin
      if (~enable) begin
        Data_o <= 4'b000;
      end
      else begin
         case (Data_i)
            2'b00  : Data_o <= 4'b001;
            2'b01  : Data_o <= 4'b010;
            2'b10  : Data_o <= 4'b100;
            2'b11  : Data_o <= 4'b000;
           default : Data_o <= 4'b000;
         endcase
      end
   end


endmodule