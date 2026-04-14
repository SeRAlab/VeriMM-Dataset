module JK_FF (
    input J,
    input K,
    input CLK,
    input RST,
    output reg Q
);
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Q <= 0;
        else begin
            case ({J, K})
                2'b00: Q <= Q;         // No change
                2'b01: Q <= 0;         // Reset
                2'b10: Q <= 1;         // Set
                2'b11: Q <= ~Q;        // Toggle
            endcase
        end
    end
endmodule