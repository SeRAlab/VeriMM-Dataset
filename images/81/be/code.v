module top_module(SW4, SW3, SW2, SW1, SW0, LEDG, LEDR, HEX0, CLK);input SW4, SW3, SW2, SW1, SW0, CLK;
    output LEDG, LEDR;
    output reg [6:0] HEX0; // Change to reg type to allow assignment in always block

    assign LEDG = ~SW0;
    assign LEDR = SW0;

    always @(posedge CLK) begin
        case ({SW4, SW3, SW2, SW1, SW0})
            5'b00000: HEX0 = 7'b1000000; // "0"
            5'b00001: HEX0 = 7'b1111001; // "1"
            5'b00010: HEX0 = 7'b0100100; // "2"
            5'b00011: HEX0 = 7'b0110000; // "3"
            5'b00100: HEX0 = 7'b0011001; // "4"
            5'b00101: HEX0 = 7'b0010010; // "5"
            5'b00110: HEX0 = 7'b0000010; // "6"
            5'b00111: HEX0 = 7'b1111000; // "7"
            5'b01000: HEX0 = 7'b0000000; // "8"
            5'b01001: HEX0 = 7'b0010000; // "9"
            default: HEX0 = 7'b1001111; // "E"
        endcase
    end

endmodule