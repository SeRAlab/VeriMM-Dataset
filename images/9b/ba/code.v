module top_module(
    input  clock,
    input  reset_n,
    input  a,
    output y
);parameter S0 = 1'b0, S1 = 1'b1;

    reg state, next_state;

    

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            state <= S0;
        else
            state <= next_state;

    

    always @*
        case (state)

        S0:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        S1:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        default:

            next_state = S0;

        endcase

    

    assign y = (a & state == S1);endmodule