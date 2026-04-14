module top_module(
  input clk,
  input areset,  // async active-high reset to zero
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] shift_q,
  output reg [15:0] jc_q,
  output reg [7:0] xor_output
);reg [15:0] jc_next;
  reg [3:0] shift_next;

  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      jc_q <= 16'b0;
      shift_q <= 4'b0;
    end else begin
      if (load) begin
        shift_q <= data;
      end else if (ena) begin
        shift_q <= {shift_q[2:0], 1'b0};
      end
      jc_next[0] <= jc_q[15] ^ jc_q[0];
      jc_next[1] <= jc_q[0] ^ jc_q[1];
      jc_next[2] <= jc_q[1] ^ jc_q[2];
      jc_next[3] <= jc_q[2] ^ jc_q[3];
      jc_next[4] <= jc_q[3] ^ jc_q[4];
      jc_next[5] <= jc_q[4] ^ jc_q[5];
      jc_next[6] <= jc_q[5] ^ jc_q[6];
      jc_next[7] <= jc_q[6] ^ jc_q[7];
      jc_next[8] <= jc_q[7] ^ jc_q[8];
      jc_next[9] <= jc_q[8] ^ jc_q[9];
      jc_next[10] <= jc_q[9] ^ jc_q[10];
      jc_next[11] <= jc_q[10] ^ jc_q[11];
      jc_next[12] <= jc_q[11] ^ jc_q[12];
      jc_next[13] <= jc_q[12] ^ jc_q[13];
      jc_next[14] <= jc_q[13] ^ jc_q[14];
      jc_next[15] <= jc_q[14] ^ jc_q[15];
      jc_q <= jc_next;
    end
  end

  always @* begin
    xor_output = {shift_q[3] ^ jc_q[0], shift_q[2] ^ jc_q[1], shift_q[1] ^ jc_q[2], shift_q[0] ^ jc_q[3], jc_q[4] ^ jc_q[5], jc_q[6] ^ jc_q[7], jc_q[8] ^ jc_q[9], jc_q[10] ^ jc_q[11]};
  end

endmodule