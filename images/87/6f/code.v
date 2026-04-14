module top_module(CLK, LOAD, IN, OUT);input CLK, LOAD;
  input [15:0] IN;
  output reg [15:0] OUT;

  always @(posedge CLK) begin
    if (LOAD) begin
      OUT <= IN;
    end else begin
      OUT <= {OUT[14:0], 1'b0};
    end
  end

endmodule