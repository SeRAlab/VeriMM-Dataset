module fsm (
    input clk,
    input reset,
    input t,
    input u,
    output reg q);

    parameter M=0, N=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= M;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            M: next = t ? N : M;
            N: next = t ? N : M;
            default: next = 'x;
        endcase
    end
    
    assign q = (state == N && u);
    
endmodule