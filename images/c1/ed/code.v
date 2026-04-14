module pulse_generator(
  input clk,
  output reg pulse
);

  reg [4:0] counter = 0;

  always @(posedge clk) begin
    if (counter == 4'b10000) begin
      counter <= 0;
      pulse <= 1;
    end else if (counter == 4'b00000) begin
      pulse <= 0;
      counter <= counter + 1;
    end else begin
      pulse <= 0;
      counter <= counter + 1;
    end
  end

endmodule