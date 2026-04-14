module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg x,
    output reg y
    );always @(a or b or c or d)
    begin
        if( !( ( a && c ) ^ ( b && d ) ) )
            x=1;
        else if ( !( b && d ) )
            x=1;
        else
            x=0;
    end
    
    always @(a or b or c or d)
        begin
            if( !( a && !c ) )
                y=1;
            else if( d && ( a ^ b ) && c )
                y=1;
            else if( d && ( !b || a ) )
                y=1;
            else
                y=0; 
        end
endmodule