module top_module(

    output reg horizontalsync,
    input [9:0] state

    );always@(state)
    begin
        if(state>95) horizontalsync=0;
        if(state<96) horizontalsync=1;
    end
endmodule