module loadable_counter(
    input clk,
    input rst,
    input en,
    input load,
    input [15:0] load_value,
    output reg [15:0] count
);

always @(posedge clk)
begin
  if (rst)
    count <= 0;
  else if (load)
    count <= load_value;
  else if (en)
    count <= count + 1;
end

endmodule