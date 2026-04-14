module mux4to1 (
  input [7:0] data0,
  input [7:0] data1,
  input [7:0] data2,
  input [7:0] data3,
  input sel0,
  input sel1,
  output reg [7:0] out
);

  always @(*) begin
    case ({sel1, sel0})
      2'b00: out = data0;
      2'b01: out = data1;
      2'b10: out = data2;
      2'b11: out = data3;
    endcase
  end

endmodule