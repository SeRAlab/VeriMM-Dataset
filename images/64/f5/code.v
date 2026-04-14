module top_module(output reg [1:0] foo,
   input wire in0, en0,
   input wire in1, en1
   );localparam foo_default = 2'b00;
   always @*
     begin
	foo = foo_default;
	if (en0) foo[0] = in0;
	if (en1) foo[1] = in1;
     end

endmodule