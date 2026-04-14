module JK_flip_flop (
    input wire J,
    input wire K,
    input wire Clock,
    input wire Reset,
    input wire Preset,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(posedge Clock or posedge Reset or posedge Preset) begin
        if (Reset) begin
            Q <= 0;
        end else if (Preset) begin
            Q <= 1;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;          // No Change
                2'b01: Q <= 0;          // Reset
                2'b10: Q <= 1;          // Set
                2'b11: Q <= ~Q;         // Toggle
            endcase
        end
    end
endmodule