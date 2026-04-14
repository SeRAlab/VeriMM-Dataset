module top_module(
    input [31:0] addr,
    output reg [31:0] eff_addr // Changed to reg type
);reg [3:0] mod; // module type

    always @(*) begin
        case (addr[31:28])
            4'b0000: mod = 4'b0000; // ROM
            4'b0001: mod = 4'b0001; // RAM
            4'b1111: begin // Other module types
                case (addr[27:20])
                    8'h00: mod = 4'b0010; // UART
                    8'h01: mod = 4'b0011; // Switches
                    8'h02: mod = 4'b0100; // LEDs
                    8'h03: mod = 4'b0101; // GPIO
                    8'h04: mod = 4'b0110; // VGA
                    8'h05: mod = 4'b0111; // PLPID
                    8'h06: mod = 4'b1000; // Timer
                    8'h07: mod = 4'b1010; // Interrupt
                    8'h08: mod = 4'b1011; // PMC
                    8'h0A: mod = 4'b1001; // SSEG
                    default: mod = 4'b0000; // Default to ROM
                endcase
            end
            default: mod = 4'b0000; // Default to ROM
        endcase
    end

    always @(*) begin
        case (mod)
            4'b0001: eff_addr = {8'h00, addr[23:0]}; // RAM
            default: eff_addr = {12'h000, addr[19:0]}; // Other module types and ROM
        endcase
    end

endmodule