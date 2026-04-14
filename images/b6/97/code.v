module top_module(
  input clk,
  input rst,
  input load_data,
  input [7:0] data_in,
  output [7:0] q_parallel,
  output q
);reg [7:0] shift_reg;
  reg [7:0] parallel_data;

  assign q_parallel = shift_reg;
  assign q = shift_reg[0];

  always @(posedge clk) begin
    if (rst) begin
      shift_reg <= 8'b0;
    end else if (load_data) begin
      shift_reg <= parallel_data;
    end else begin
      shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
  end

  always @(posedge clk) begin
    if (load_data) begin
      parallel_data <= data_in;
    end
  end

endmodule