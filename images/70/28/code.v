module top_module(
  input [11:0] I,
  input S,
  output O
);wire [3:0] select = {S, S, S, S};
  wire [3:0] not_select = ~select;
  wire [11:0] selected_inputs = (select & I) | (not_select & I[11:0]);

  assign O = selected_inputs[11];

endmodule