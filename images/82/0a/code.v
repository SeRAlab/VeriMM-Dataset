module top_module(select, data_i00, data_i01, data_i02, data_i03, data_o);parameter Size = 8;

   input wire [1:0] select;
   input wire [Size-1:0] data_i00;
   input wire [Size-1:0] data_i01;
   input wire [Size-1:0] data_i02;
   input wire [Size-1:0] data_i03;

   output reg [Size-1:0] data_o;

   always @ (select or data_i00 or data_i01 or data_i02 or data_i03) begin
      case (select)
         2'b00: data_o = data_i00;
         2'b01: data_o = data_i01;
         2'b10: data_o = data_i02;
         2'b11: data_o = data_i03;
         default: data_o = 0;
      endcase
   end

endmodule