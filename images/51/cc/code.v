module top_module(
    input wire J,
    input wire K,
    input wire CLK,
    input wire CLR,
    output reg Q);always @(posedge CLK) begin
  if (!CLR)
    if(J==1'b0 && K==1'b1) begin
      Q <= 'b0;
    end
    else if(J==1'b1 && K==1'b0) begin
      Q <= 1'b1;
    end
    else if(J==1'b1 & K==1'b1) begin
      Q <= ~Q;
    end
  else 
     Q<=0;
  end
endmodule