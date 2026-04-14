module top_module(
  input ref_clk,
  input feedback_clk,
  input in_data,
  output out_data
);parameter delay_amount = 4; // amount of delay in clock cycles.

reg [delay_amount-1:0] delayed_clk; // register to store delayed clock signals

always @(posedge ref_clk) begin
  delayed_clk <= {delayed_clk[delay_amount-2:0], 1'b0}; // shift in a new bit and shift out the oldest bit
end

reg [delay_amount-1:0] feedback_delayed_clk; // register to store delayed feedback clock signals

always @(posedge feedback_clk) begin
  feedback_delayed_clk <= {feedback_delayed_clk[delay_amount-2:0], 1'b0}; // shift in a new bit and shift out the oldest bit
end

reg [delay_amount-1:0] delayed_in_data; // register to store delayed input data signals

always @(posedge delayed_clk[delay_amount-1]) begin
  delayed_in_data <= {delayed_in_data[delay_amount-2:0], in_data}; // shift in a new input data and shift out the oldest input data
end

reg [delay_amount-1:0] delayed_out_data; // register to store delayed output data signals

always @(posedge feedback_delayed_clk[delay_amount-1]) begin
  delayed_out_data <= {delayed_out_data[delay_amount-2:0], delayed_in_data[delay_amount-1]}; // shift in a new delayed input data and shift out the oldest delayed input data
end

assign out_data = delayed_out_data[delay_amount-1]; // output the delayed output data signal

endmodule