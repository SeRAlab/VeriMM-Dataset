module voltage_regulator (
    input [4:0] voltage_ref,
    output reg [4:0] regulated_output
);

always @(*) begin
    case (voltage_ref)
        5'b00000: regulated_output = 5'd0;
        5'b00001: regulated_output = 5'd1;
        5'b00010: regulated_output = 5'd2;
        5'b00011: regulated_output = 5'd3;
        5'b00100: regulated_output = 5'd4;
        5'b00101: regulated_output = 5'd5;
        5'b00110: regulated_output = 5'd6;
        5'b00111: regulated_output = 5'd7;
        5'b01000: regulated_output = 5'd8;
        5'b01001: regulated_output = 5'd9;
        5'b01010: regulated_output = 5'd10;
        5'b01011: regulated_output = 5'd11;
        5'b01100: regulated_output = 5'd12;
        5'b01101: regulated_output = 5'd13;
        5'b01110: regulated_output = 5'd14;
        5'b01111: regulated_output = 5'd15;
        5'b10000: regulated_output = 5'd16;
        5'b10001: regulated_output = 5'd17;
        5'b10010: regulated_output = 5'd18;
        5'b10011: regulated_output = 5'd19;
        5'b10100: regulated_output = 5'd20;
        5'b10101: regulated_output = 5'd21;
        5'b10110: regulated_output = 5'd22;
        5'b10111: regulated_output = 5'd23;
        5'b11000: regulated_output = 5'd24;
        5'b11001: regulated_output = 5'd25;
        5'b11010: regulated_output = 5'd26;
        5'b11011: regulated_output = 5'd27;
        5'b11100: regulated_output = 5'd28;
        5'b11101: regulated_output = 5'd29;
        5'b11110: regulated_output = 5'd30;
        5'b11111: regulated_output = 5'd31;
        default: regulated_output = 5'd0; // default case
    endcase
end

endmodule