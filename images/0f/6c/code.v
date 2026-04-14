module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q,
    output reg Qn
);
    always @(posedge CLK) begin
        case ({J, K})
            2'b00: Q <= Q;           // No change
            2'b01: Q <= 1'b0;        // Reset
            2'b10: Q <= 1'b1;        // Set
            2'b11: Q <= ~Q;          // Toggle
        endcase
        Qn <= ~Q;                   // Complement of Q
    end
endmodule