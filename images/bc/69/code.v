module top_module(
input   [1:0] sel_port,
input   [31:0] port_in_0,
input   [31:0] port_in_1,
input   [31:0] port_in_2,
input   [31:0] port_in_3,
output reg [31:0] port_out 
);always @(*) begin
   case (sel_port)
      2'd0: port_out <= port_in_0;
      2'd1: port_out <= port_in_1;
      2'd2: port_out <= port_in_2;
      default: port_out <= port_in_3;
	endcase
end

endmodule