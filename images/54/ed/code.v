module top_module(
    input clk,
    input reset,
    input parallel_load,
    input shift,
    input [3:0] input_data,
    input [2:0] ABC,
    output reg [7:0] output_data  // Changed from wire to reg
);reg [3:0] shift_reg;
    wire [7:0] decoder_out;

    // Shift-left register with parallel load and asynchronous reset
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            shift_reg <= 4'b0;
        end else if (parallel_load) begin
            shift_reg <= input_data;
        end else if (shift) begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

    // 3-to-8 decoder with active low outputs
    assign decoder_out = {
        (ABC == 3'b000) ? 1'b0 : 1'b1,
        (ABC == 3'b001) ? 1'b0 : 1'b1,
        (ABC == 3'b010) ? 1'b0 : 1'b1,
        (ABC == 3'b011) ? 1'b0 : 1'b1,
        (ABC == 3'b100) ? 1'b0 : 1'b1,
        (ABC == 3'b101) ? 1'b0 : 1'b1,
        (ABC == 3'b110) ? 1'b0 : 1'b1,
        (ABC == 3'b111) ? 1'b0 : 1'b1
    };

    // Functional module that outputs the corresponding value from the 3-to-8 decoder
    always @(*) begin
        case (shift_reg)
            4'b0000: output_data = {7'b0, decoder_out[0]};
            4'b0001: output_data = {7'b0, decoder_out[1]};
            4'b0010: output_data = {7'b0, decoder_out[2]};
            4'b0011: output_data = {7'b0, decoder_out[3]};
            4'b0100: output_data = {7'b0, decoder_out[4]};
            4'b0101: output_data = {7'b0, decoder_out[5]};
            4'b0110: output_data = {7'b0, decoder_out[6]};
            4'b0111: output_data = {7'b0, decoder_out[7]};
            4'b1000: output_data = 8'b0;
            4'b1001: output_data = 8'b0;
            4'b1010: output_data = 8'b0;
            4'b1011: output_data = 8'b0;
            4'b1100: output_data = 8'b0;
            4'b1101: output_data = 8'b0;
            4'b1110: output_data = 8'b0;
            4'b1111: output_data = 8'b0;
            default: output_data = 8'b0; // Handle default case
        endcase
    end

endmodule