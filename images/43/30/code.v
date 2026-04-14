module top_module(
	 input clk,
	 input rst,
    input ADC_0,
    input ADC_1,
    input ADC_2,
	 input ADC_3,
    input ADC_4,
    input ADC_5,
    input ADC_6,
    input ADC_7,
    output reg [7:0] Data
    );always @(posedge clk or posedge rst)
      if (rst) begin
         Data[0] <= 0;
			Data[1] <= 0;
			Data[2] <= 0;
			Data[3] <= 0;
			Data[4] <= 0;
			Data[5] <= 0;
			Data[6] <= 0;
			Data[7] <= 0;
      end else begin
         Data[0] <= ~ADC_0;
			Data[1] <= ~ADC_1;
			Data[2] <= ~ADC_2;
			Data[3] <= ~ADC_3;
			Data[4] <= ~ADC_4;
			Data[5] <= ~ADC_5;
			Data[6] <= ~ADC_6;
			Data[7] <= ~ADC_7;
      end
		

endmodule