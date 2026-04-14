module top_module(
    input sys_clk_i,
    input sys_rst_i,
    input j1_io_rd,
    input j1_io_wr,
    input [15:0] j1_io_addr,
    output reg [15:0] j1_io_din,  // Changed output to reg
    output reg [7:0] cs,
    input [15:0] mult_dout,
    input [15:0] div_dout,
    input [15:0] uart_dout, // Changed type to match j1_io_dout
    input [15:0] dp_ram_dout,
    input [15:0] bt_dout,
    input [15:0] audio_dout,
    input [15:0] ultra_dout,
    input echo
);// Address decoder
    always @* begin
        case (j1_io_addr[15:8])
            8'h63: cs = 8'b10000000; // altavoz
            8'h64: cs = 8'b01000000; // ultra
            8'h65: cs = 8'b00100000; // audio
            8'h66: cs = 8'b00010000; // bt
            8'h67: cs = 8'b00001000; // mult
            8'h68: cs = 8'b00000100; // div
            8'h69: cs = 8'b00000010; // uart
            8'h70: cs = 8'b00000001; // dp_ram
            default: cs = 8'b00000000; // no peripheral selected
        endcase
    end

    // Multiplexer
    always @* begin
        case (cs)
            8'b10000000: j1_io_din = audio_dout; // altavoz
            8'b01000000: j1_io_din = ultra_dout; // ultra
            8'b00100000: j1_io_din = audio_dout; // audio
            8'b00010000: j1_io_din = bt_dout; // bt
            8'b00001000: j1_io_din = mult_dout; // mult
            8'b00000100: j1_io_din = div_dout; // div
            8'b00000010: j1_io_din = uart_dout; // uart
            8'b00000001: j1_io_din = dp_ram_dout; // dp_ram
            default: j1_io_din = 16'h0000; // no peripheral selected
        endcase
    end

endmodule