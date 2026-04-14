module top_module(clk, rst, load, in, out);input clk, rst, load, in;
  output reg [7:0] out;

  always @(posedge clk) begin
    if (rst) begin
      out <= 8'b0;
    end
    else if (load) begin
      out <= in;
    end
    else begin
      out <= {out[6:0], in};
    end
  end

endmodule