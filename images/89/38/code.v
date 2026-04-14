module fsm (
    input clk,
    input reset,
    input g,
    input h,
    output reg v);

    parameter P=0, Q=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= P;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            P: next = g ? Q : P;
            Q: next = g ? Q : P;
            default: next = 'x;
        endcase
    end
    
    assign v = (state == Q && !h);
    
endmodule