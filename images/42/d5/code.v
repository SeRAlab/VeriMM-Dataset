module fsm (
    input clk,
    input reset,
    input x,
    output reg z);

    parameter S0=0, S1=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            S0: next = x ? S1 : S0;
            S1: next = x ? S1 : S0;
            default: next = 'x;
        endcase
    end
    
    assign z = (state == S1 && !x);
    
endmodule