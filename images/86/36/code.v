module top_module(
    data1_i,
    data2_i,
    select_i,
    data_o
);input wire [31:0] data1_i;
input wire [31:0] data2_i;
input wire select_i;
output reg [31:0] data_o;

always @(data1_i or data2_i or select_i)
begin
  data_o=(select_i==1'b1)? data2_i :data1_i;
end

endmodule