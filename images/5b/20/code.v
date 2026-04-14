module top_module(
    input D,
    input SET_ASYNC,
    input SLEEP_B,
    output reg Q
);always @(negedge SET_ASYNC or negedge SLEEP_B or posedge D)
    begin
        if(!SET_ASYNC)
            Q <= D;
        else if(!SLEEP_B)
            Q <= 0;
    end

endmodule