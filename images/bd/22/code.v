module top_module(
  input [1:0] connectStateIn,
  input resumeDetectedIn,
  input clk,
  input rst,
  output reg resetEventOut,
  output reg [1:0] connectStateOut,
  output reg resumeIntOut
);always @ (posedge clk) begin
    if (rst) begin
      resetEventOut <= 0;
      connectStateOut <= connectStateIn;
      resumeIntOut <= 0;
    end else begin
      if (connectStateIn != connectStateOut) begin
        resetEventOut <= 1;
      end else begin
        resetEventOut <= 0;
      end

      connectStateOut <= connectStateIn;

      if (resumeDetectedIn && !resumeIntOut) begin
        resumeIntOut <= 1;
      end else begin
        resumeIntOut <= 0;
      end
    end
  end

endmodule