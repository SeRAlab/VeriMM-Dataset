module inc (
    input      [3:0] i,
    input      [3:0] inc_val,
    output reg [3:0] o
  );

  // Behaviour
  always @(*)
    o = i + inc_val;
endmodule