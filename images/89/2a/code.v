module top_module(
  input clk, load, 
  input [7:0] in,
  output reg [7:0] out);always @(posedge clk)
    begin
      if (load)
       out=in;
      else 
        begin
          if (out[3:0]==4'd9)
            begin
              out[3:0]=4'd0;
              if (out[7:4]==4'd9)out[7:4]=4'd0;
              else out[7:4]=out[7:4]+4'd1;
            end
          else out[3:0]=out[3:0]+4'd1;
        end
    end
endmodule