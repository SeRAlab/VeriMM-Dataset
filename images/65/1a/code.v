module shift_register(
    input clk,
    input rst,
    input load,
    input [7:0] data_in,
    output [7:0] data_out
);

reg [7:0] data_out;

always@(posedge clk or posedge rst)
begin
  if(rst)
    data_out <= 0;
  else if(load)
    data_out <= data_in;
  else
    data_out <= data_out << 1;
end

endmodule