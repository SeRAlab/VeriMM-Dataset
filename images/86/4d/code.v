module top_module(

  input clk, rst, w_en,
  input [15:0] data_in,

  output reg [15:0] data_out
);always@(posedge clk or negedge rst) begin
    if(rst == 1'b0) begin
      data_out <= 16'd0;
    end else begin
      if(w_en == 1'b1) begin
        data_out <= data_in;
      end else begin
		  data_out <= data_out;
		end
    end 
  end 
 
endmodule