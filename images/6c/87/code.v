module fsm (
    input clk,
    input reset,
    input a,
    output reg b);

    parameter START=0, END=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= START;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            START: next = a ? END : START;
            END: next = a ? END : START;
            default: next = 'x;
        endcase
    end
    
    assign b = (state == END && !a);
    
endmodule