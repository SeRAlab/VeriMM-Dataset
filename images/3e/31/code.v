module encoder_4to2 (
    input wire I0,
    input wire I1,
    input wire I2,
    input wire I3,
    output reg Y0,
    output reg Y1
);
    always @(*) begin
        case ({I3, I2, I1, I0})
            4'b1000: {Y1, Y0} = 2'b11; // I3 is highest priority
            4'b0100: {Y1, Y0} = 2'b10; // I2
            4'b0010: {Y1, Y0} = 2'b01; // I1
            4'b0001: {Y1, Y0} = 2'b00; // I0
            default: {Y1, Y0} = 2'bxx;  // No input
        endcase
    end
endmodule