module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] in,   // 8-bit input for the shift register
    input [63:0] sel, // Select input to choose from 16 4-bit inputs
    output reg [1:0] out // 2-bit output from the functional module
);reg [7:0] shift_reg; // Shift register to shift input by two positions to the left
reg [3:0] mux_out;   // Output from the 16-to-1 multiplexer
reg cmp_out;         // Output from the comparator

// Shift register
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {in[7:2], 2'b0};
    end
end

// 16-to-1 multiplexer
always @(*) begin
    case (sel[5:4])
        2'b00: mux_out = in[3:0];
        2'b01: mux_out = in[7:4];
        2'b10: mux_out = in[11:8];
        2'b11: mux_out = in[15:12];
    endcase
end

// Comparator
always @(*) begin
    if (mux_out == 4'b1010) begin
        cmp_out = 1'b1;
    end else begin
        cmp_out = 1'b0;
    end
end

// Functional module
always @(*) begin
    out[1:0] = {cmp_out, shift_reg[7:6]} | {cmp_out, shift_reg[5:4]} | {cmp_out, shift_reg[3:2]} | {cmp_out, shift_reg[1:0]};
end

endmodule