module top_module(
    input clk,
    input in,
    input areset,
    output reg out
);     // State Encoding
    parameter A = 0, B = 1, C = 2, D = 3;
    reg [1:0] state, next;

    // State Transition Logic
    always @(*) begin
        case (state)
            A: next = in ? C : C;
            B: next = in ? B : A;
            C: next = in ? B : A;
            D: next = in ? D : A;
        endcase
    end

    // State Register with Asynchronous Reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next;
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: out = 1;
            B: out = 1;
            C: out = 1;
            D: out = 1;
        endcase
    end
endmodule
