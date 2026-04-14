module top_module(
  input ClrW,
  input Wclk,
  input Start,
  input nRclk,
  input RE,
  input H_L,
  input [11:0] Depth,
  input [11:0] PerCnt,
  input [31:0] Delay,
  output reg Sampled,  // Change to reg
  output reg Ready,    // Change to reg
  output reg Full,     // Change to reg
  output Empty,        // Keep as wire
  output reg [11:0] Wptr, // Change to reg
  output reg [11:0] Rptr  // Change to reg
);reg Loaded;
  reg [12:0] Pcnt;
  reg [11:0] Bptr;
  reg [31:0] DelayCnt;

  assign Empty = (Rptr == Wptr) ? 1'b1 : 1'b0;

  always @(posedge Wclk or posedge ClrW) begin
    if (ClrW) begin
      Full <= 0;
      Pcnt <= 0;
      Sampled <= 0;
      DelayCnt <= 0;
      Ready <= 0;
    end else begin
      if (Start) DelayCnt <= DelayCnt + 1;
      if (Pcnt >= PerCnt) Sampled <= 1;
      if (!Full) Wptr <= Wptr + 1;
      if (Pcnt >= Depth) Full <= Ready;
      else Pcnt <= Pcnt + 1;
      if ((!Start) && (Pcnt >= PerCnt)) Pcnt <= PerCnt;
      if (DelayCnt == Delay) begin
        Ready <= 1;
        Bptr <= Wptr;
        Pcnt <= PerCnt;
      end
    end
  end

  always @(posedge nRclk or posedge ClrW) begin
    if (ClrW) begin
      Loaded <= 0;
      Rptr <= 0;
    end else begin
      if (H_L && RE) Rptr <= Rptr + 1;
      if ((H_L) && RE && (~Loaded) && Start) begin
        Loaded <= 1;
        Rptr <= Bptr - 151;
      end
    end
  end

endmodule