module constant_generator (
  output reg [7:0] op,
  input clk,
  input ce,
  input clr
);

  always @(posedge clk) begin
    if (clr) begin
      op <= 8'b0;
    end else if (ce) begin
      op <= 8'b00000001;
    end
  end

endmodule