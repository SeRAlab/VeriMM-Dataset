module top_module(
  output out,
  input en,
  input in
);reg en_latched ;

  always @(en or in) begin
     if (!in) begin
        en_latched = en;
     end
  end

  assign out = en_latched && in;

endmodule