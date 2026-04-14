module top_module(
    input clk,
    input [2:0] in,
    input [7:0] d,
    output [10:0] q
);reg [2:0] shift_reg;
    reg [7:0] piso_reg;
    reg [10:0] final_output;

    always @(posedge clk) begin
        // Shift left by one bit position
        shift_reg <= {shift_reg[1:0], in[2]};
    end

    always @(negedge clk) begin
        // PISO shift register
        piso_reg <= {d, piso_reg[7:1]};
    end

    always @* begin
        // Concatenate the outputs of the shift register and PISO shift register
        final_output = {shift_reg, piso_reg};
    end

    assign q = final_output;

endmodule