module vending_machine (
    input clk,
    input resetn,
    input coin,
    output reg dispense);

    parameter IDLE = 0, PAID = 1;
    reg state, next_state;

    always @(posedge clk) begin
        if (~resetn) state <= IDLE;
        else state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE: next_state = coin ? PAID : IDLE;
            PAID: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(state) begin
        case (state)
            PAID: dispense = 1;
            default: dispense = 0;
        endcase
    end
endmodule