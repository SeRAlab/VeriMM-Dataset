module encoder4to2 (
    input [3:0] I,
    input EN,
    output reg [1:0] Y
);
    always @(*) begin
        if (EN) begin
            case (I)
                4'b0000: Y = 2'bxx; // All inputs low
                4'b0001: Y = 2'b00; // I0 is high
                4'b0010: Y = 2'b01; // I1 is high
                4'b0100: Y = 2'b10; // I2 is high
                4'b1000: Y = 2'b11; // I3 is high
                4'b0011: Y = 2'b01; // I1 or I0 high, I1 takes priority
                4'b0101: Y = 2'b10; // I2 or I0 high, I2 takes priority
                4'b1001: Y = 2'b11; // I3 or I0 high, I3 takes priority
                4'b0110: Y = 2'b10; // I2 or I1 high, I2 takes priority
                4'b1010: Y = 2'b11; // I3 or I1 high, I3 takes priority
                4'b1100: Y = 2'b11; // I3 or I2 high, I3 takes priority
                default: Y = 2'bxx; // Undefined case
            endcase
        end else begin
            Y = 2'bxx; // Enable low, outputs are undefined
        end
    end
endmodule