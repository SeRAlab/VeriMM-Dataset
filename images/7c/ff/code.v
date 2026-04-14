module fsm (
    input clk,
    input reset,
    input r,
    input s,
    output reg p);

    parameter V=0, W=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= V;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            V: next = r ? W : V;
            W: next = r ? W : V;
            default: next = 'x;
        endcase
    end
    
    assign p = (state == W && !s);
    
endmodule