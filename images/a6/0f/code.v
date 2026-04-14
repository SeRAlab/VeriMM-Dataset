module top_module(
input [7:0] in1_mux3,in2_mux3,in3_mux3,in4_mux3,
input [1:0] sel_mux3,
output reg [7:0]o_mux3

    );always @(*)
  begin
      case (sel_mux3)
         2'b00: o_mux3 = in3_mux3;
         2'b01: o_mux3 = in4_mux3;
         2'b10: o_mux3 = in1_mux3;
         2'b11: o_mux3 = in2_mux3;
      endcase
	end

endmodule