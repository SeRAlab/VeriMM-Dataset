module top_module(
    input clk,
    input areset,      // Asynchronous active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    input [3:0] in,    // Input for the priority encoder
    output [3:0] q     // Final 4-bit output
);// Priority Encoder
    wire [1:0] enc_out;
    assign enc_out = (in[3]) ? 2'b11 :
                     (in[2]) ? 2'b10 :
                     (in[1]) ? 2'b01 :
                               2'b00 ;

    // Shift Register
    reg [3:0] shift_reg;
    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            shift_reg <= 4'b0000;
        end else if (load) begin
            shift_reg <= data;
        end else if (ena) begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
    end

    // Functional Module
    reg [3:0] result;
    always @(*) begin
        case (enc_out)
            2'b00: result = shift_reg;
            2'b01: result = {1'b1, shift_reg[3:1]} + shift_reg;
            2'b10: result = {2'b10, shift_reg[3:2]} + shift_reg;
            2'b11: result = {3'b111, shift_reg[3]} + shift_reg;
        endcase
    end

    assign q = result;

endmodule