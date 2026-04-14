module top_module(
  input [7:0] a,
  input [7:0] b,
  input sel,
  output reg [15:0] mux_out
);always @(*) begin
    if (sel == 1'b0) begin
      mux_out = {a, 8'b0};
    end
    else begin
      mux_out = {8'b0, b};
    end
  end
  
endmodule