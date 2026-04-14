module mux_4to1_if_else (
  input [1:0] a,
  input [1:0] b,
  input [1:0] sel,
  output reg [1:0] out
);

  always @(*) begin
    if(sel == 2'b00) begin
      out = a;
    end
    else if(sel == 2'b01) begin
      out = b;
    end
    else if(sel == 2'b10) begin
      out = a & b;
    end
    else begin // sel == 2'b11
      out = a | b;
    end
  end

endmodule
