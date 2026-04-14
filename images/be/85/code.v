module top_module(x,y,CLR,C,Q);input x,y;
wire g;
input CLR, C;
reg tmp;
output Q;


assign g = x*y;


always @(posedge C or posedge CLR)
    begin 
      if (CLR) 
        tmp <= 4'b0000; 
      else 
        tmp <= tmp + g; 
    end 

assign Q = tmp; 

endmodule