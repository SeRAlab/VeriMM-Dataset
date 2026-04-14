module encoder_4_to_2 (
    input wire I3,
    input wire I2,
    input wire I1,
    input wire I0,
    output reg [1:0] O,
    output reg valid
);
    always @(*) begin
        valid = 1'b0; // Default to invalid
        if (I3) begin
            O = 2'b11; // Encode I3
            valid = 1'b1;
        end else if (I2) begin
            O = 2'b10; // Encode I2
            valid = 1'b1;
        end else if (I1) begin
            O = 2'b01; // Encode I1
            valid = 1'b1;
        end else if (I0) begin
            O = 2'b00; // Encode I0
            valid = 1'b1;
        end else begin
            O = 2'bxx; // No valid input
        end
    end
endmodule