module rising_edge_counter(
  input wire clk,
  input wire reset,
  output wire [31:0] count
);

  reg [31:0] count_reg;

  always @(posedge clk) begin
    if (reset) begin
      count_reg <= 0;
    end else begin
      count_reg <= count_reg + 1;
    end
  end

  assign count = count_reg;

endmodule