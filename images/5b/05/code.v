module top_module(
    input PB,
    input CLK,
    output ENos
    );reg X, Y, Z;

assign ENos = Y & ~Z;







always @(posedge CLK) begin
    X <= PB;    
    Y <= X;
    Z <= Y;
   
    end
 

    

endmodule