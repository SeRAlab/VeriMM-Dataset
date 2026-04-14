module fsm (
    input clk,
    input reset,
    input a,
    input b,
    output reg w);

    parameter A=0, B=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            A: next = a ? B : A;
            B: next = a ? B : A;
            default: next = 'x;
        endcase
    end
    
    assign w = (state == B && b);
    
endmodule