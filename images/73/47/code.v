module top_module(input INP, input CLK, input [7:0] N, input VDD, input VSS, output reg Z);reg [7:0] count;

  always @(posedge CLK) begin
    if (INP) begin
      Z <= 1'b1;
      count <= 0;
    end else begin
      Z <= count < N;
      count <= count + 1;
    end
  end

endmodule