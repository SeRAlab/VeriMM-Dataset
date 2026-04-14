module top_module(
    input D,
    input RESET,
    input SET,
    input CLK,
    output Q
);wire Qn;
    wire n_RESET, n_SET;

    // Invert RESET and SET signals
    not(n_RESET, RESET);
    not(n_SET, SET);

    // Implement the D flip-flop (using a behavioral description)
    reg Q_reg; // Register to hold the state of Q

    always @(posedge CLK or negedge n_RESET or negedge n_SET) begin
        if (!n_RESET) begin
            Q_reg <= 1'b0; // Reset the output
        end else if (!n_SET) begin
            Q_reg <= 1'b1; // Set the output
        end else begin
            Q_reg <= D; // Store input D in Q_reg on CLK edge
        end
    end

    // Assign registered value to output Q
    assign Q = Q_reg;

endmodule