module top_module(
  input [31:0] reg_data_in,mem_data_in,
  input load,enable,
  output reg [31:0] data_out
);always @(*) begin
    data_out = reg_data_in;
    if(load == 1'b1 && enable == 1'b1) data_out = mem_data_in;
  end
endmodule