module top_module(
  input clk,
  input reset,
  input load,
  input data,
  output [7:0] q
);reg [7:0] shift_reg;

always @(posedge clk) begin
  if (reset == 1'b0) begin
    shift_reg <= 8'b0;
  end else begin
    if (load == 1'b1) begin
      shift_reg <= data;
    end else begin
      shift_reg <= {shift_reg[6:0], data};
    end
  end
end

assign q = shift_reg;

endmodule