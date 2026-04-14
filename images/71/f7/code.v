module top_module(
  input [3:0] A, B,
  input sub, Cin,
  output reg [3:0] Y,  // Changed output type from wire to reg
  output reg Cout, OVF
);reg [4:0] temp;
  
  always @(*) begin
    if (sub) begin
      temp = A - B - Cin;
      Y = temp[3:0];
      Cout = ~temp[4];
      OVF = (temp < -8) ? 1 : 0;
    end else begin
      temp = A + B + Cin;
      Y = temp[3:0];
      Cout = temp[4];
      OVF = (temp > 7) ? 1 : 0;
    end
  end
  
endmodule