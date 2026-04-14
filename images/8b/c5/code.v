module top_module(
  input MTxClk,
  input Reset,
  input StateJam,
  input StateJam_q,
  input [3:0] RetryCnt,
  input [15:0] NibCnt,
  input [9:0] ByteCnt,
  output RandomEq0,
  output RandomEqByteCnt
);// Feedback polynomial: x^10 + x^3 + 1
  wire Feedback = ~(x[2] ^ x[9]);

  // LFSR state
  reg [9:0] x;

  // Random number
  wire [9:0] Random;

  // Latched random number
  reg [9:0] RandomLatched;

  // Initialize LFSR to zero on reset
  always @(posedge MTxClk or posedge Reset) begin
    if (Reset) begin
      x <= #1 10'b0;
    end else begin
      x <= #1 {x[8:0], Feedback};
    end
  end

  // Generate random number based on LFSR output and RetryCnt
  assign Random[0] = x[0];
  assign Random[1] = (RetryCnt > 1) ? x[1] : 1'b0;
  assign Random[2] = (RetryCnt > 2) ? x[2] : 1'b0;
  assign Random[3] = (RetryCnt > 3) ? x[3] : 1'b0;
  assign Random[4] = (RetryCnt > 4) ? x[4] : 1'b0;
  assign Random[5] = (RetryCnt > 5) ? x[5] : 1'b0;
  assign Random[6] = (RetryCnt > 6) ? x[6] : 1'b0;
  assign Random[7] = (RetryCnt > 7) ? x[7] : 1'b0;
  assign Random[8] = (RetryCnt > 8) ? x[8] : 1'b0;
  assign Random[9] = (RetryCnt > 9) ? x[9] : 1'b0;

  // Latch random number on positive edge of MTxClk when StateJam is high and StateJam_q is low
  always @(posedge MTxClk) begin
    if (StateJam & ~StateJam_q) begin
      RandomLatched <= #1 Random;
    end
  end

  // Random number == 0
  assign RandomEq0 = (RandomLatched == 10'b0);

  // Random number == ByteCnt ANDed with bitwise AND of nibbles in NibCnt
  assign RandomEqByteCnt = (RandomLatched == (ByteCnt & &NibCnt[6:0]));

endmodule