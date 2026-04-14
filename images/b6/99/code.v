module top_module(wave0,wave1,wave2,wave3,wave4,wave5,wave6,wave7,wave8,wave9,wave10,wave11,wave12,wave);input [9:0] wave0,wave1,wave2,wave3,wave4,wave5,wave6,wave7,wave8,wave9,wave10,wave11,wave12;

output reg [13:0] wave;

always @(wave0,wave1,wave2,wave3,wave4,wave5,wave6,wave7,wave8,wave9,wave10,wave11,wave12) begin
	wave <= wave0+wave1+wave2+wave3+wave4+wave5+wave6+wave7+wave8+wave9+wave10+wave11+wave12;
end

endmodule