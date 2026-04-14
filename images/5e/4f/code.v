module top_module(
  input clk,
  input reset,
  input [31:0] in_vec,
  input control,
  output reg [31:0] out_vec
);always @(posedge clk, posedge reset) begin
    if (reset) begin
      out_vec <= 0;
    end else begin
      if (control) begin
        out_vec[15:0] <= in_vec[31:16];
        out_vec[31:16] <= in_vec[15:0];
      end else begin
        out_vec <= in_vec;
      end
    end
  end

endmodule