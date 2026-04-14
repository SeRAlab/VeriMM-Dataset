module top_module(input rstn,
   input iclk,
   input oclk,
   input ipulse,
   output opulse);reg pulse0, pulse1, pulse2;

  assign opulse = pulse1 & ~pulse2;

  always @(posedge iclk or negedge rstn) begin
    if (~rstn)
      pulse0 <= 1'b0;
    else if (ipulse)
      pulse0 <= 1'b1;
  end

  always @(posedge oclk or negedge rstn) begin
    if (~rstn) begin
      pulse1 <= 1'b0;
      pulse2 <= 1'b0;
    end else begin
      pulse1 <= pulse0;
      pulse2 <= pulse1;
    end
  end
endmodule