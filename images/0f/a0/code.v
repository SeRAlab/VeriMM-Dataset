module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q,
    output Qn
);
    assign Qn = ~Q;
    
    always @(posedge CLK) begin
        case ({J, K})
            2'b00: Q <= Q;      // No change
            2'b01: Q <= 0;      // Reset
            2'b10: Q <= 1;      // Set
            2'b11: Q <= ~Q;     // Toggle
        endcase
    end
endmodule