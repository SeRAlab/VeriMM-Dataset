module JK_flip_flop (
    input J,
    input K,
    input Clock,
    input Reset,
    output reg Q,
    output reg Qn
);
    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;        // No change
                2'b01: Q <= 1;        // Set
                2'b10: Q <= 0;        // Reset
                2'b11: Q <= ~Q;       // Toggle
            endcase
            Qn <= ~Q;                 // Complement output
        end
    end
endmodule