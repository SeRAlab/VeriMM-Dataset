module top_module(
    input j,k,CP,reset,
    output reg y,ybar
    );always @(reset)
    begin
        if(reset == 1)
        y = 0;
        ybar = 1;
    end
    always @(negedge CP)
    begin 
        y = (j&(~y))|((~k)&y);
        ybar = ~y;
    end
endmodule