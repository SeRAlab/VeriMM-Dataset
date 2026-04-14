module JK_flip_flop (
    input J,
    input K,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        case ({J, K})
            2'b01: Q <= 0;   // Reset
            2'b10: Q <= 1;   // Set
            2'b11: Q <= ~Q;  // Toggle
            default: Q <= Q; // Hold
        endcase
    end
endmodule