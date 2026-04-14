module sprinkler_system (
    input clk,
    input resetn,
    input enable,
    output reg sprinkling);

    parameter OFF = 0, ON = 1;
    reg state, next_state;

    always @(posedge clk) begin
        if (~resetn) state <= OFF;
        else state <= next_state;
    end

    always_comb begin
        case (state)
            OFF: next_state = enable ? ON : OFF;
            ON: next_state = enable ? ON : OFF;
            default: next_state = OFF;
        endcase
    end

    always @(state) begin
        case (state)
            ON: sprinkling = 1;
            default: sprinkling = 0;
        endcase
    end
endmodule