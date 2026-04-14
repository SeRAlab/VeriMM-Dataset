module top_module(a,b,c,d,e,f,g,h,sel,y);input [15:0] a,b,c,d,e,f,g,h;
  input [2:0] sel;
  output reg [15:0] y;

  always@(y,sel)
  begin
    if(sel == 3'b000) begin
      y = a;
    end
    else if(sel == 3'b001) begin
      y = b;
    end
    else if(sel == 3'b010) begin
      y = c;
    end
    else if(sel == 3'b011) begin
      y = d;
    end
    else if(sel == 3'b100) begin
      y = e;
    end
    else if(sel == 3'b101) begin
      y = f;
    end
    else if(sel == 3'b110) begin
      y = g;
    end
    else if(sel == 3'b111) begin
      y = h;
    end
  end
endmodule