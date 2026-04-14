module JK_FF (
    input J,
    input K,
    input Clock,
    input Reset,
    output reg Q
);
    always @(posedge Clock or posedge Reset) begin
        if (Reset)
            Q <= 0;
        else begin
            case ({J, K})
                2'b00: Q <= Q;      // No change
                2'b01: Q <= 0;      // Reset
                2'b10: Q <= 1;      // Set
                2'b11: Q <= ~Q;     // Toggle
            endcase
        end
    end
endmodule