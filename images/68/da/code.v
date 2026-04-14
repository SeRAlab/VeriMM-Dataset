module top_module(
    input clk,
    input [2:0] parallel_load,
    input shift,
    input control,
    input A, B,
    output reg [15:0] Y
);reg [2:0] shift_reg;
reg [15:0] decoder_out;

always @(posedge clk) begin
    if (control == 1'b0) begin
        // Shift right
        shift_reg <= {shift_reg[2:1], shift_reg[0]};  // Corrected order
    end else begin
        // Shift left
        shift_reg <= {shift_reg[1:0], shift_reg[2]};  // Changed to correct left shift
    end

    if (shift == 1'b1) begin
        // Shift in parallel_load value
        shift_reg <= parallel_load;
    end

    decoder_out <= 16'b0;
    case ({A, B})
        2'b00: decoder_out[shift_reg] = 1'b0;
        2'b01: decoder_out[shift_reg >> 1] = 1'b0;
        2'b10: decoder_out[shift_reg >> 2] = 1'b0;
        2'b11: decoder_out[shift_reg >> 3] = 1'b0;
    endcase

    Y <= ~decoder_out;
end

endmodule