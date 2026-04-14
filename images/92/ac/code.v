module top_module(
  input clk_ref,
  input [n-1:0] ctrl,
  output reg clk_syn
);parameter n = 8; // number of bits used to represent the division ratio
parameter f_max = 100; // maximum output frequency that can be generated

reg [n-1:0] count; // binary counter for division ratio
reg [n-1:0] max_count; // maximum count value based on control signal
reg [31:0] divider; // divider to limit maximum output frequency

always @ (posedge clk_ref) begin
  if (count == max_count) begin
    count <= 0;
    clk_syn <= ~clk_syn;
  end else begin
    count <= count + 1;
  end
end

always @ (ctrl) begin
  max_count <= 2**ctrl;
  divider <= f_max * max_count;
end

endmodule