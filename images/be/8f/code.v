module top_module(
    input D, RESET_B, CLK,
    output reg Q, Q_N
);always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0; // Reset state
        end else begin
            Q <= D; // Set state
        end
    end

    assign Q_N = ~Q; // Complement of Q

endmodule