module top_module(
    input clk,
    input in,
    input reset,
    output reg out
);     // State Encoding
    parameter A = 0, B = 1;
    reg [1:0] state, next;

    // State Transition Logic
    always @(*) begin
        case (state)
            A: next = in ? A : B;
            B: next = in ? B : B;
        endcase
    end

    // State Register with synchronous Reset
    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next;
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: out = 1;
            B: out = 0;
        endcase
    end
endmodule
