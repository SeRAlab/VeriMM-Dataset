module top_module(din ,clk ,dout );output dout ;
reg dout ;

input din ;
input clk ;


reg [2:0]s;

always @ (posedge clk) 
begin 
        s[0] <= din ;
        s[1] <= s[0] ;
        s[2] <= s[1] ;
        dout <= s[2]; 
end

endmodule