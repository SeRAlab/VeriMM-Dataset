module fsm (
    input clk,
    input reset,
    input m,
    input n,
    output reg u);

    parameter I=0, J=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state <= I;
        else state <= next;
    end
    
    always_comb begin
        case (state)
            I: next = m ? J : I;
            J: next = m ? J : I;
            default: next = 'x;
        endcase
    end
    
    assign u = (state == J && n);
    
endmodule