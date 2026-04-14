module top_module(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input [1:0] CTRL,
    output [7:0] C,
    output VALID
);reg [7:0] C_reg; // Output register
    reg VALID_reg; // Valid signal register

    always @(posedge clk) begin
        if (rst) begin
            C_reg <= 8'h00;
            VALID_reg <= 1'b0;
        end else begin
            case (CTRL)
                2'b00: C_reg <= A + B; // addition
                2'b01: C_reg <= A - B; // subtraction
                2'b10: C_reg <= A * B; // multiplication
                2'b11: C_reg <= A / B; // division
            endcase

            VALID_reg <= 1'b1; // Set valid signal
        end
    end

    assign C = C_reg;
    assign VALID = VALID_reg;

endmodule