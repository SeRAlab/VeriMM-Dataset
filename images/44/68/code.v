module top_module(
		input [31:0]            wr_data,
		input                   wr_en,
		output reg [31:0] 	rd_data,
		output [1:0]            rd_guards ,
		output [1:0]            rd_guardsok ,
		input                   clk
		);always @(posedge clk) begin
      if (wr_en)
	begin
           rd_data <= wr_data;
	end
   end

   
   

   assign rd_guards= {
		      rd_data[0],
		      1'b1
		      };

   assign rd_guardsok[0] = 1'b1;
   assign rd_guardsok[1] = rd_data[0];

endmodule