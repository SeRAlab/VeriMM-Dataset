module top_module(input [3:0] a,
                input        clk, reset,
                output  reg [3:0] y1, y2);always @ (posedge clk, posedge  reset)
      begin
          if(reset) y1 <= 4'b0;
          else y1 <= a;
      end
    always @ (posedge clk)
      begin
          if (reset) y2 <= 4'b0;
          else y2 <= a;
      end
endmodule