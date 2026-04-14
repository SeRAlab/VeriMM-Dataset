module fsm (
    input clk,
    input reset,
    input x,
    output reg z);

    parameter INIT=0, READY=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= INIT;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            INIT: next = x ? READY : INIT;
            READY: next = x ? READY : INIT;
            default: next = 'x;
        endcase
    end
    
    assign z = (state == READY && !x);
    
endmodule