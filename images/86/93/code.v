module top_module(
  input clk,
  input reset_n,
  input [15:0] start_gen,
  input [15:0] root_gen,
  output reg data_valid,
  output reg [7:0] root
);always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      data_valid <= 0;
      root       <= 0;
    end
    else begin
      data_valid <= start_gen[15];
      if (root_gen[15:8] > root_gen[7:0])
        root <= root_gen[15:8] + 1;
      else
        root  <= root_gen[7:0];
    end
  end

endmodule