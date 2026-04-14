module and_gate (
  input A,
  input B,
  input CLK,
  input RST,
  output reg Y
);

  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      Y <= 0;
    end else begin
      Y <= A & B;
    end
  end

endmodule