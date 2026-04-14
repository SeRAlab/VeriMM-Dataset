module top_module(
  input clk,
  input reset,
  input enable,
  input [7:0] data_in,
  output [7:0] data_out
);reg [7:0] reg_0, reg_1, reg_2, reg_3, reg_4;

  always @(posedge clk, negedge reset) begin
    if(!reset) begin
      reg_0 <= 8'b0;
      reg_1 <= 8'b0;
      reg_2 <= 8'b0;
      reg_3 <= 8'b0;
      reg_4 <= 8'b0;
    end else begin
      if(enable) begin
        reg_4 <= reg_3;
        reg_3 <= reg_2;
        reg_2 <= reg_1;
        reg_1 <= reg_0;
        reg_0 <= data_in;
      end
    end
  end

  assign data_out = reg_4;

endmodule