module top_module(
    input clk,
    input reset,            // Synchronous reset
    input [15:0] in,       // 16-bit input to the multiplexer
    output reg [7:0] q      // 8-bit output of the final module
);reg [3:0] sel;          // Selection signal for the multiplexer
    reg [15:0] shift_reg;   // 16-bit shift register

    // Shift register with synchronous reset and negative edge trigger
    always @(negedge clk) begin
        if (reset) begin
            shift_reg <= 16'h0000;
        end else begin
            shift_reg <= {shift_reg[14:0], in[0]};
        end
    end

    // Multiplexer with 16 inputs and 1 output
    always @* begin
        case (sel)
            4'b0000: q = in[15:8] ^ shift_reg[7:0];
            4'b0001: q = in[14:7] ^ shift_reg[7:0];
            4'b0010: q = in[13:6] ^ shift_reg[7:0];
            4'b0011: q = in[12:5] ^ shift_reg[7:0];
            4'b0100: q = in[11:4] ^ shift_reg[7:0];
            4'b0101: q = in[10:3] ^ shift_reg[7:0];
            4'b0110: q = in[9:2] ^ shift_reg[7:0];
            4'b0111: q = in[8:1] ^ shift_reg[7:0];
            4'b1000: q = in[7:0] ^ shift_reg[7:0];
            4'b1001: q = in[15:8] ^ shift_reg[15:8];
            4'b1010: q = in[14:7] ^ shift_reg[15:8];
            4'b1011: q = in[13:6] ^ shift_reg[15:8];
            4'b1100: q = in[12:5] ^ shift_reg[15:8];
            4'b1101: q = in[11:4] ^ shift_reg[15:8];
            4'b1110: q = in[10:3] ^ shift_reg[15:8];
            4'b1111: q = in[9:2] ^ shift_reg[15:8];
        endcase
    end

    // Selection signal for the multiplexer from the shift register
    always @(posedge clk) begin
        if (reset) begin
            sel <= 4'b0000;
        end else begin
            sel <= shift_reg[3:0];
        end
    end

endmodule