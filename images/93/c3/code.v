module top_module( CLK, EN, ENCLK, TE );input CLK, EN, TE;
  output ENCLK;

  reg [63:0] data;
  reg enable_latch;

  always @(posedge TE) begin
    enable_latch <= EN;
  end

  always @(posedge CLK) begin
    if (enable_latch) begin
      data <= $past(data, 1);
    end
  end

  assign ENCLK = enable_latch ? data : 1'b0;
endmodule