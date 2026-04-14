module top_module(
  input clk,
  input reset,
  input [7:0] in,
  input select,
  output [15:0] out
);reg [15:0] out_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      out_reg <= 16'b0;
    end else begin
      if (select) begin
        out_reg <= {8'b0, in};
      end else begin
        out_reg <= {in, 8'b0};
      end
    end
  end

  assign out = out_reg;

endmodule