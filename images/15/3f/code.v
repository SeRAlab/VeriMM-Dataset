module JK_FF (
    input wire J,
    input wire K,
    input wire Clock,
    input wire Clear,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(posedge Clock or posedge Clear) begin
        if (Clear) begin
            Q <= 0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;        // No change
                2'b01: Q <= 0;        // Reset
                2'b10: Q <= 1;        // Set
                2'b11: Q <= ~Q;       // Toggle
            endcase
        end
    end
endmodule