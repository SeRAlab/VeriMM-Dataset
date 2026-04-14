module top_module(
    output reg Q,
    output Q_N,
    input D,
    input CLK,
    input SET_B,
    input RESET_B
);// The Q_N output is complementary to Q
    assign Q_N = ~Q;

    always @ (posedge CLK or negedge SET_B or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0;  // Reset state
        end else if (!SET_B) begin
            Q <= 1'b1;  // Set state
        end else begin
            Q <= D;     // Normal operation
        end
    end

endmodule