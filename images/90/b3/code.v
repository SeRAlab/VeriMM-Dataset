module shift_register(
    input clk,
    input rst,
    input serial_in,

    output [7:0] parallel_out
);

reg [7:0] parallel_out;

always @(posedge clk or posedge rst)
begin
  if (rst)
    parallel_out <= 8'b00000000;
  else
    parallel_out <= {serial_in, parallel_out[7:1]};
end

endmodule