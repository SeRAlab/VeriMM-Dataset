module top_module(
    input [7:0] data_i,
    input [2:0] shift_i,
    output [2:0] data_o
    );reg [15:0] tmp;
   always @*
      case (shift_i)
         3'b000: tmp = data_i;
         3'b001: tmp = data_i << 1;
         3'b010: tmp = data_i << 2;
         3'b011: tmp = data_i << 3;
         3'b100: tmp = data_i << 4;
         3'b101: tmp = data_i << 5;
         3'b110: tmp = data_i << 6;
         default: tmp = data_i << 7;
      endcase
	assign data_o = tmp[7:5];endmodule