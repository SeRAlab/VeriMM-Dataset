module shift_register (
  input clk,
  input load,
  input [7:0] data,
  output reg [7:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= {1'b0, q[7:1]};
    end
  end

endmodule