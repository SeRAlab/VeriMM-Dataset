module fsm (
    input clk,
    input reset,
    input x,
    output reg z);

    parameter IDLE=0, RUNNING=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            IDLE: next = x ? RUNNING : IDLE;
            RUNNING: next = x ? RUNNING : IDLE;
            default: next = 'x;
        endcase
    end
    
    assign z = (state == RUNNING && !x);
    
endmodule