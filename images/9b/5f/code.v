module top_module(
  input clk,
  input rst_n,
  input [7:0] shreg,
  output reg a_i
);reg [7:0] shreg_r; // Changed to a vector to allow bit selection
reg set_a_i_flag;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    shreg_r <= 8'b00110011;
    a_i <= 0;
    set_a_i_flag <= 0;
  end
  else begin
    shreg_r <= shreg;
    if (set_a_i_flag) begin
      a_i <= shreg_r[0];
      set_a_i_flag <= 0;
    end
  end
end

always @(posedge clk) begin
  set_a_i_flag <= 1;
end

endmodule