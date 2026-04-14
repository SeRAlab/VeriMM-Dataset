module top_module (
    input clk,
    input x,
    input k,
    input reset,
    output reg out);// State Encoding
    parameter OFF = 0, ON = 1;
    reg [1:0] state, next;

    // State Transition Logic
    always @(*) begin
        case (state)
            OFF: next = x ? ON : OFF;
            ON: next = k ? OFF : ON;
        endcase
    end

    // State Register with synchronous Reset
    always @(posedge clk) begin
        if (reset) state <= OFF;
        else state <= next;
    end

    // Output Logic
    always @(*) begin
        case (state)
            OFF: out = 0;
            ON: out = 1;
        endcase
    end
endmodule