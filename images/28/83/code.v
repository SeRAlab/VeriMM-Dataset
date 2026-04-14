module encoder_4to2 (
    input wire I3, I2, I1, I0,
    output reg Y1, Y0
);
    always @(*) begin
        case ({I3, I2, I1, I0})
            4'b0000: {Y1, Y0} = 2'b00; // No input active
            4'b0001: {Y1, Y0} = 2'b00; // Input 0 active
            4'b0010: {Y1, Y0} = 2'b01; // Input 1 active
            4'b0100: {Y1, Y0} = 2'b10; // Input 2 active
            4'b1000: {Y1, Y0} = 2'b11; // Input 3 active
            default: {Y1, Y0} = 2'b00;  // Default case (shouldn't occur)
        endcase
    end
endmodule