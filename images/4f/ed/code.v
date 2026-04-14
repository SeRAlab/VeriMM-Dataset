module top_module(mole16bit, mole_position);input [15:0] mole16bit;
    output reg [4:0] mole_position;  // Declare mole_position as reg
    
    always @* begin
        case (mole16bit)
            16'b0000_0000_0000_0001: mole_position = 5'b00000;
            16'b0000_0000_0000_0010: mole_position = 5'b00001;
            16'b0000_0000_0000_0100: mole_position = 5'b00010;
            16'b0000_0000_0000_1000: mole_position = 5'b00011;
            16'b0000_0000_0001_0000: mole_position = 5'b00100;
            16'b0000_0000_0010_0000: mole_position = 5'b00101;
            16'b0000_0000_0100_0000: mole_position = 5'b00110;
            16'b0000_0000_1000_0000: mole_position = 5'b00111;
            16'b0000_0001_0000_0000: mole_position = 5'b01000;
            16'b0000_0010_0000_0000: mole_position = 5'b01001;
            16'b0000_0100_0000_0000: mole_position = 5'b01010;
            16'b0000_1000_0000_0000: mole_position = 5'b01011;
            16'b0001_0000_0000_0000: mole_position = 5'b01100;
            16'b0010_0000_0000_0000: mole_position = 5'b01101;
            16'b0100_0000_0000_0000: mole_position = 5'b01110;
            16'b1000_0000_0000_0000: mole_position = 5'b01111;
            default: mole_position = 5'b00000;
        endcase
    end
endmodule