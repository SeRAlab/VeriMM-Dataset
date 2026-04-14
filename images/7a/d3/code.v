module bidir_shift_reg(
    input clk,
    input rst,
    input load,
    input dir,
    input [15:0] parallel_in,

    output reg [15:0] parallel_out
);

always @(posedge clk or posedge rst)
begin
  if (rst)
    parallel_out <= 16'b0000000000000000;
  else if (load)
    parallel_out <= parallel_in;
  else if (dir)
    parallel_out <= {parallel_out[14:0], 1'b0};
  else
    parallel_out <= {1'b0, parallel_out[15:1]};
end

endmodule