module top_module(
  input clk,
  input reset,
  output reg [3:0] count_out
);reg j, k;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    count_out <= 4'b0000;
    j <= 1'b0;
    k <= 1'b0;
  end
  else begin
    case ({j,k})
      2'b00: begin // Qn-1 = 0, Qn = 0
        count_out <= count_out + 1;
        j <= 1'b1;
      end
      2'b01: begin // Qn-1 = 0, Qn = 1
        j <= 1'b0;
        k <= 1'b1;
      end
      2'b10: begin // Qn-1 = 1, Qn = 0
        j <= 1'b1;
        k <= 1'b0;
      end
      2'b11: begin // Qn-1 = 1, Qn = 1
        j <= 1'b1;
        k <= 1'b1;
      end
    endcase
  end
end

endmodule