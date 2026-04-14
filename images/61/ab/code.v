module top_module(
  input clk,
  input ctrl,
  output reg vout
);parameter fmin = 1000000; // minimum frequency of the VCO (1 MHz)
parameter fmax = 2000000; // maximum frequency of the VCO (2 MHz)
parameter vmin = 0; // minimum voltage that corresponds to fmin
parameter vmax = 1; // maximum voltage that corresponds to fmax

reg pwm;
reg [7:0] counter;

always @(posedge clk) begin
  if (counter == 8'hFF) begin
    counter <= 8'h00;
    pwm <= (ctrl) ? 1'b1 : 1'b0;
  end else begin
    counter <= counter + 1;
  end
end

assign vout = (pwm) ? vmax : vmin;

endmodule