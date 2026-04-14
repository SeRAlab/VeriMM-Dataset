module left_shift_register (
  input clk,
  input clear,
  input load,
  input [7:0] data,
  output reg [7:0] q
);

  always @(posedge clk) begin
    if (clear) begin
      q <= 8'b00000000;
    end
    else if (load) begin
      q <= data;
    end
    else begin
      q <= {q[6:0], 1'b0};
    end
  end

endmodule