module JK_FF (
    input J,
    input K,
    input CLK,
    input CLR,
    output reg Q,
    output Qn
);
    assign Qn = ~Q;

    always @(posedge CLK or posedge CLR) begin
        if (CLR) begin
            Q <= 1'b0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;       // No change
                2'b01: Q <= 1'b0;    // Reset
                2'b10: Q <= 1'b1;    // Set
                2'b11: Q <= ~Q;      // Toggle
            endcase
        end
    end
endmodule