module top_module(
    input         clk,
    input         rst,
    input  [3:0]  btn,
    output reg [3:0] out
  );always @(posedge clk, posedge rst)
    begin
      if (rst) out <= 4'b0;
      else
        case (btn)
          4'b1110: out <= 4'b0001; // Button 1
          4'b1101: out <= 4'b0010; // Button 2
          4'b1011: out <= 4'b0100; // Button 3
          4'b0111: out <= 4'b1000; // Button 4
          default: out <= 4'b0000; // No button pressed
        endcase
    end

endmodule