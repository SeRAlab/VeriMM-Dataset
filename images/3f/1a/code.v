module mux2to1 (
    input wire [4:0] a,
    input wire [4:0] b,
    input wire sel,
    input wire power_gating,
    output reg [4:0] y
);
    always @(*) begin
        if (!power_gating) begin
            y = 5'b00000; // Output is off when power gating is active
        end else begin
            case (sel)
                1'b0: y = a; // Select input a
                1'b1: y = b; // Select input b
                default: y = 5'b00000; // Default case
            endcase
        end
    end
endmodule