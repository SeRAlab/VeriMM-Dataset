module top_module(y,a,b);input a;
    input b;
    output [3:0]y;
    reg [3:0]y;
    always@(a or b)
    begin
        if(a == 0&&b == 0)
            y = 2'b00;
        else if(a == 1 && b == 0)
            y = 2'b01;
        else if(a == 0 && b == 1)
            y = 2'b10;
        else if(a == 1 && b ==1)
            y = 2'b11;
    end     
        
        
endmodule