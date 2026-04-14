module pipeline_register (
  input clk,
  input reset,
  input [31:0] data_in,
  output [31:0] data_out
);

  reg [31:0] data_reg;

  always @(posedge clk) begin
    if (reset) begin
      data_reg <= 0;
    end else begin
      data_reg <= data_in;
    end
  end

  assign data_out = data_reg;

endmodule