module top_module(
  input PB1,
  output LED1,
  output LED2,
  output CDONE_A,
  input OSC_CLK_A
);localparam bits = 24;
  reg [bits-1:0] counter = 0;

  always @(posedge OSC_CLK_A) begin
    counter <= counter + 1;
  end

  assign {LED1, LED2} = counter[bits-1:bits-2];
  assign CDONE_A = ~PB1;

endmodule