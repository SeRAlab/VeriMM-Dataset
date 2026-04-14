module fsm (
    input clk,
    input reset,
    input u,
    input v,
    output reg t);

    parameter R=0, S=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= R;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            R: next = u ? S : R;
            S: next = u ? S : R;
            default: next = 'x;
        endcase
    end
    
    assign t = (state == S && !v);
    
endmodule