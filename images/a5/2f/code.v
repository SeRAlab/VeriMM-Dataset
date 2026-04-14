module top_module(input [15:0] in, input reset, output reg [31:0] out);always @(*) begin
    if (reset) begin
      out <= 0;
    end
    else begin
      out <= {in, (~in) + 1'b1}; // Use 1'b1 for proper width
    end
  end

endmodule