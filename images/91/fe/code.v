module fsm (
    input clk,
    input reset,
    input x,
    output reg z);

    parameter START=0, ACTIVE=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= START;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            START: next = x ? ACTIVE : START;
            ACTIVE: next = x ? ACTIVE : START;
            default: next = 'x;
        endcase
    end
    
    assign z = (state == ACTIVE && !x);
    
endmodule