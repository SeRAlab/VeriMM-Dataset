module top_module(
                  input clk,
                  input [4:0] x,
                  input xval,
                  input rst,
                  output reg [4:0] y,
                  output reg yval
                  );reg signed [4:0] ym1;

   always @(posedge clk) begin 
        if (rst) begin
            y <= 0;
            ym1 <= 0;
            yval <=0;
        end
        else if(xval) begin
            ym1 <= y;
            yval <=0;
        end
        else begin
            
            y <= ym1 + x >> 1; 
            yval <=1 ;
        end



   end

endmodule