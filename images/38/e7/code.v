module power_gated_mux (
    input [4:0] A,
    input [4:0] B,
    input sel,
    input power_gate,
    output reg [4:0] Y
);
    always @(*) begin
        if (power_gate) begin
            case (sel)
                1'b0: Y = A;
                1'b1: Y = B;
                default: Y = 5'b00000; // Default case
            endcase
        end else begin
            Y = 5'b00000; // Power gated state
        end
    end
endmodule