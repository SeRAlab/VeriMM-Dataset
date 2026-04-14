module top_module(
    input D,
    input RESET_B,
    input CLK,
    output reg Q, // Changed to output reg
    output Q_N
);assign Q_N = ~Q; // No change needed here

    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0;
        end
        else begin
            Q <= D;
        end
    end

endmodule