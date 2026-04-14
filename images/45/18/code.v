module top_module(
  input [LOGWORD-1:0] value,
  output reg [WORD-1:0] gauge  // Change wire to reg, so it can be assigned in always block
);localparam LOGWORD = 7;
  localparam WORD = (1 << LOGWORD);

  reg [LOGWORD-1:0] i;
  wire [WORD-1:0] o;

  assign o = {1'b0, {LOGWORD{1'b1}}, 1'b0};  // Fix: Use LOGWORD to create the width of 'o'

  always @ (*) begin
    gauge = 0;  // Initialize gauge
    for (i = 0; i < LOGWORD; i = i + 1) begin
      if (value[i] == 1'b1) begin
        gauge = o >> (LOGWORD - i);  // Assign gauge
      end
    end
  end

endmodule