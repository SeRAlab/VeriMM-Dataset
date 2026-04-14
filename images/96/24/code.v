module top_module(
  input in0,
  input in1,
  input in2,
  input in3,
  input sel,
  input en,
  output out
);reg selected;

  always @(*) begin
    if (sel == 2'b00) begin
      selected = in0;
    end else if (sel == 2'b01) begin
      selected = in1;
    end else if (sel == 2'b10) begin
      selected = in2;
    end else begin
      selected = in3;
    end
  end

  assign out = en ? selected : 1'b0;

endmodule