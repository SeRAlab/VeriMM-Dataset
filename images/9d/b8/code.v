module top_module(clk, rst, en, count);input clk; //clock input
  input rst; //reset input
  input en; //enable input
  output reg [3:0] count; //4-bit output
  
  always @(posedge clk) begin
    if (rst) begin //reset to 0
      count <= 0;
    end else if (en) begin //increment when enable is high
      if (count == 9) begin //reset to 0 when count reaches 9
        count <= 0;
      end else begin
        count <= count + 1; //increment by 1
      end
    end
  end
endmodule