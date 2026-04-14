module top_module(output [3:0] x);wire signed [3:0] y,z;
assign y=4'b1101;
assign z=4'b1001;
assign x=y*z;
endmodule