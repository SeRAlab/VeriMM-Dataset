module top_module(
    input D,
    input CLK,
    output reg Q  // Change to reg to hold state
);wire GATE_N;

    assign GATE_N = ~CLK;

    always @(posedge CLK) begin
        Q <= D;  // Use a simple always block to implement the D flip-flop
    end

endmodule