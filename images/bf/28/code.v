module top_module(
    input [7:0] I,
    output reg EN,
    output reg [2:0] Y  // Changed wire to reg
);always @(*) begin
    EN = 1; // Default enable signal set to 1
    Y = 3'b000; // Default output for Y

    case (I)
        8'b00000001: begin
            EN = 0;
            Y = 3'b000; // Use 3-bit binary value
        end
        8'b00000010: begin
            EN = 0;
            Y = 3'b001; // Use 3-bit binary value
        end
        8'b00000100: begin
            EN = 0;
            Y = 3'b010; // Use 3-bit binary value
        end
        8'b00001000: begin
            EN = 0;
            Y = 3'b011; // Use 3-bit binary value
        end
        8'b00010000: begin
            EN = 0;
            Y = 3'b100; // Use 3-bit binary value
        end
        8'b00100000: begin
            EN = 0;
            Y = 3'b101; // Use 3-bit binary value
        end
        8'b01000000: begin
            EN = 0;
            Y = 3'b110; // Use 3-bit binary value
        end
        8'b10000000: begin
            EN = 0;
            Y = 3'b111; // Use 3-bit binary value
        end
        default: begin
            EN = 1;
            Y = 3'b000; // Default case for Y
        end
    endcase
end

endmodule