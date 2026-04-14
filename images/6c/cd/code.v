module top_module(i_0r0, i_0r1, i_0a, o_0r0, o_0r1, reset);input [4:0] i_0r0;
  input [4:0] i_0r1;
  output i_0a;
  output [4:0] o_0r0;
  output [4:0] o_0r1;
  input reset;

  reg [4:0] r_0r0;
  reg [4:0] r_0r1;
  reg r_0a;

  always @(posedge reset or negedge reset) begin
    if (reset) begin
      r_0r0 <= 5'b0;
      r_0r1 <= 5'b0;
      r_0a <= 1'b0;
    end else begin
      r_0r0 <= i_0r0;
      r_0r1 <= i_0r1;
      r_0a <= (|i_0r0) | (|i_0r1);

      if ((i_0r0[4:2] + i_0r1[4:2]) >= (i_0r0[1:0] + i_0r1[1:0])) begin
        if ((i_0r0[4:2] - i_0r0[1:0]) > (i_0r1[4:2] - i_0r1[1:0])) begin
          r_0a <= 1'b1;
        end
      end
    end
  end

  assign o_0r0 = r_0r0;
  assign o_0r1 = r_0r1;
  assign i_0a = r_0a;

endmodule