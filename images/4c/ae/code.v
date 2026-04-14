module top_module(
  input CLK,
  input RSTB,
  output [3:0] Q
);reg [3:0] count;

  always @(posedge CLK) begin
    if (!RSTB) begin
      count <= 4'b0000;
    end else begin
      count <= count + 4'b0001;
    end
  end

  assign Q = count;

endmodule