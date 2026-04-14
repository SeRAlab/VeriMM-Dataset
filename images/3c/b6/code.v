module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q,
    output reg Qn
);
    always @(posedge CLK) begin
        case ({J, K})
            2'b00: begin
                // No change
                Q <= Q;
            end
            2'b01: begin
                // Reset
                Q <= 0;
            end
            2'b10: begin
                // Set
                Q <= 1;
            end
            2'b11: begin
                // Toggle
                Q <= ~Q;
            end
        endcase
        Qn <= ~Q; // Qn is always the complement of Q
    end
endmodule