module fsm (
    input clk,
    input reset,
    input l,
    input m,
    output reg s);

    parameter D=0, E=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= D;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            D: next = l ? E : D;
            E: next = l ? E : D;
            default: next = 'x;
        endcase
    end
    
    assign s = (state == E && m);
    
endmodule