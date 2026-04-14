module binary_counter (
  input CLK, RST,
  output [3:0] Q
);

  reg [3:0] count;

  always @(posedge CLK) begin
    if (RST) begin
      count <= 4'b0000;
    end else begin
      count <= count + 1;
    end
  end

  assign Q = count;

endmodule