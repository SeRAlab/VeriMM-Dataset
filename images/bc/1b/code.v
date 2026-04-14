module top_module(
    input CLOCK, Reset, S1, S0,
    input [7:0] P, BeginCount, EndCount,
    output reg [7:0] Q,
    output reg TerminalCount
);always @ (posedge CLOCK or posedge Reset) begin
    if (Reset) begin
        Q <= BeginCount;
        TerminalCount <= 0;
    end
    else begin
        case ({S1, S0})
            2'b00: begin // Hold mode
                Q <= Q;
                TerminalCount <= 0;
            end
            2'b01: begin // Count up mode
                if (Q == EndCount) begin
                    Q <= BeginCount;
                    TerminalCount <= 1;
                end
                else begin
                    Q <= Q + 1;
                    TerminalCount <= 0;
                end
            end
            2'b10: begin // Count down mode
                if (Q == BeginCount) begin
                    Q <= EndCount;
                    TerminalCount <= 1;
                end
                else begin
                    Q <= Q - 1;
                    TerminalCount <= 0;
                end
            end
            2'b11: begin // Parallel load mode
                Q <= P;
                TerminalCount <= 0;
            end
        endcase
    end
end

endmodule