module top_module(clock, c_in, d_in, out1);// SIGNAL DECLARATIONS
input clock;
input c_in;
input d_in;
output out1;
reg out1;
reg temp;

always @(posedge clock)
begin
	out1 <= temp - d_in;
	temp <= c_in - d_in;
end

endmodule