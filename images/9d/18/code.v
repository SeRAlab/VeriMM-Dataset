module top_module(
    input  clock,
    input  reset_n,
    input  a,
    output y
);parameter [1:0] S0 = 0, S1 = 1, S2 = 2;

    reg [1:0] state, next_state;

    

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
                next_state = S2;
            else
                next_state = S1;

        S2:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        default:

            next_state = S0;

        endcase

    

    assign y = (state == S2);endmodule