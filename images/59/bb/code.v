module top_module(
    input clk,
    input in,
    input reset,
    output reg out
);     // State Encoding
    parameter A = 0, B = 1, C = 2, D = 3;
    reg [1:0] state, next;

    // State Transition Logic
    always @(*) begin
        case (state)
            A: next = in ? D : B;
            B: next = in ? B : C;
            C: next = in ? B : D;
            D: next = in ? B : B;
        endcase
    end

    // State Register with synchronous Reset
    always @(posedge clk) begin
        if (reset) state <= B;
        else state <= next;
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: out = 0;
            B: out = 0;
            C: out = 1;
            D: out = 0;
        endcase
    end
endmodule
