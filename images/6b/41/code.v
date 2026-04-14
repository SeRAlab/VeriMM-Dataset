module fsm (
    input clk,
    input reset,
    input d,
    input e,
    output reg y);

    parameter K=0, L=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= K;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            K: next = d ? L : K;
            L: next = d ? L : K;
            default: next = 'x;
        endcase
    end
    
    assign y = (state == L && e);
    
endmodule