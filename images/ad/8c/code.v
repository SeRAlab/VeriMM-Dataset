module top_module(
    input RST, // synchronous reset signal
    input CLK, // clock signal
    input STM, // start multiplication signal
    output reg ENpH, // enable Rp high
    output reg ENpL, // enable Rp low
    output reg ENa, // enable Ra
    output reg ENr, // enable Rr
    output reg SEL, // select multiplexer
    output reg EOM // end of multiplication
    );// define states
    parameter IDLE = 2'd0;
    parameter STATE1 = 2'd1;
    parameter STATE2 = 2'd2;
    parameter STATE3 = 2'd3;

    // define state register and next state logic
    reg [1:0] state, next_state;
    always @* begin
        case(state)
            IDLE: begin
                if (STM) next_state = STATE1;
                else next_state = IDLE;
                ENpH = 0;
                ENpL = 0;
                ENa = 0;
                ENr = 0;
                SEL = 0;
                EOM = 1;
            end
            STATE1: begin
                next_state = STATE2;
                ENpH = 1;
                ENpL = 0;
                ENa = 0;
                ENr = 0;
                SEL = 0;
                EOM = 0;
            end
            STATE2: begin
                next_state = STATE3;
                ENpH = 0;
                ENpL = 1;
                ENa = 1;
                ENr = 0;
                SEL = 0;
                EOM = 0;
            end
            STATE3: begin
                next_state = IDLE;
                ENpH = 0;
                ENpL = 0;
                ENa = 1;
                ENr = 1;
                SEL = 1;
                EOM = 0;
            end
        endcase
    end

    // define synchronous state update
    always @(posedge CLK, posedge RST) begin
        if (RST) state <= IDLE;
        else state <= next_state;
    end

endmodule