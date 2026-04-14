module up_counter_4bit_sync_reset (
  input CLK,
  input RST,
  output reg [3:0] Q
);

  always @(posedge CLK) begin
    if (RST) begin
      Q <= 4'b0000;
    end else begin
      Q <= Q + 1;
    end
  end

endmodule