module Reg_8_sync(
   input                clk,
   input                rst,
   input                en,
   input  [7:0]         D,
   output reg [7:0]     Q
);
    always@(posedge clk)begin
        if(rst) Q <= 8'd0;
        else if(en) Q <= D;
    end
endmodule