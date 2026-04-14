module top_module (
    input clk,
    input j,
    input x,
    input reset,
    output reg out);// State Encoding
    parameter ON = 0, OFF = 1;
    reg [1:0] state, next;

    // State Transition Logic
    always @(*) begin
        case (state)
            ON: next = j ? OFF : ON;
            OFF: next = x ? ON : OFF;
        endcase
    end

    // State Register with synchronous Reset
    always @(posedge clk) begin
        if (reset) state <= ON;
        else state <= next;
    end

    // Output Logic
    always @(*) begin
        case (state)
            ON: out = 0;
            OFF: out = 1;
        endcase
    end
endmodule