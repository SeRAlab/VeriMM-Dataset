module top_module(
	data0,
	data1,
	data10,
	data11,
	data12,
	data13,
	data14,
	data15,
	data16,
	data17,
	data18,
	data19,
	data2,
	data3,
	data4,
	data5,
	data6,
	data7,
	data8,
	data9,
	result);input	  data0;
	input	  data1;
	input	  data10;
	input	  data11;
	input	  data12;
	input	  data13;
	input	  data14;
	input	  data15;
	input	  data16;
	input	  data17;
	input	  data18;
	input	  data19;
	input	  data2;
	input	  data3;
	input	  data4;
	input	  data5;
	input	  data6;
	input	  data7;
	input	  data8;
	input	  data9;
	output	  result;

	assign result = data0 & data1 & data2 & data3 & data4 & data5 & data6 & data7 & data8 & data9 & data10 & data11 & data12 & data13 & data14 & data15 & data16 & data17 & data18 & data19;

endmodule