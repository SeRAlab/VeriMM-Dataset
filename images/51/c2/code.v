module top_module(
    output reg Q,
    input RESET_B,
    input D,
    input GATE_N
);// Local signals
    wire RESET;
    wire intgate;
    wire buf_Q;

    // Inverting RESET_B signal
    not not0 (RESET, RESET_B);
    // Inverting GATE_N signal for the latch's enable signal
    not not1 (intgate, GATE_N);

    // Behavioral description of a D latch
    always @ (D, intgate, RESET) begin
        if (RESET == 1'b1) begin
            Q <= 1'b0; // Reset output Q to 0
        end else if (intgate == 1'b0) begin
            Q <= D;    // Pass D to Q when GATE is active (conditioned by intgate)
        end
    end

endmodule