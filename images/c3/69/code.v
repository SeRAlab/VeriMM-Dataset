module bidirectional_data_port (
  input clk,
  input reset,
  input [3:0] in,
  input dir,
  output reg [3:0] out,
  output reg [3:0] dout
);

  always @(posedge clk, negedge reset) begin
    if (!reset) begin
      out <= 4'b0;
      dout <= 4'b0;
    end else begin
      if (dir == 1) begin
        out <= {in[3], in[2], in[1], in[0]};
        dout <= {in[0], in[1], in[2], in[3]};
      end else begin
        out <= in;
      end
    end
  end

endmodule
