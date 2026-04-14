module top_module(select, data_i00, data_i01, data_i02, data_i03, data_i04, data_i05, data_i06, data_i07, data_o);parameter Size = 8;

   input wire [2:0] select;
   input wire [Size-1:0] data_i00;
   input wire [Size-1:0] data_i01;
   input wire [Size-1:0] data_i02;
   input wire [Size-1:0] data_i03;
   input wire [Size-1:0] data_i04;
   input wire [Size-1:0] data_i05;
   input wire [Size-1:0] data_i06;
   input wire [Size-1:0] data_i07;

   output reg [Size-1:0] data_o;

   always @ (select or data_i00 or data_i01 or data_i02 or data_i03 or data_i04 or data_i05 or data_i06 or data_i07) begin
      case (select)
         3'b000: data_o = data_i00;
         3'b001: data_o = data_i01;
         3'b010: data_o = data_i02;
         3'b011: data_o = data_i03;
         3'b100: data_o = data_i04;
         3'b101: data_o = data_i05;
         3'b110: data_o = data_i06;
         3'b111: data_o = data_i07;
      endcase
   end

endmodule