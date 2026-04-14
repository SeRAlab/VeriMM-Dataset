module pipeline_register (
  input data_in,
  input clk,
  output data_out
);

  reg [31:0] data_reg; // register to hold the data
  always @(posedge clk) begin
    data_reg <= data_in; // latch the data_in signal on the rising edge of the clock
  end
  
  reg [31:0] data_delayed; // register to hold the delayed data
  always @(posedge clk) begin
    data_delayed <= data_reg; // delay the data_in signal by one clock cycle
  end
  
  assign data_out = data_delayed; // assign the delayed data to the output
  
endmodule