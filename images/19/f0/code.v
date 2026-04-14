module gpio_controller (
    input [2:0] mode,
    input [7:0] data_in,
    input shift_enable,
    input clk,
    output reg [7:0] gpio_out
);
    reg [7:0] shift_reg;
    
    always @(posedge clk) begin
        case (mode)
            3'b000: gpio_out <= 8'b00000000; // All low
            3'b001: gpio_out <= 8'b11111111; // All high
            3'b010: gpio_out <= data_in;      // Direct output
            3'b011: gpio_out <= ~data_in;     // Inverted output
            3'b100: begin                      // Shift Register
                if (shift_enable) begin
                    shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                    gpio_out <= shift_reg;
                end else begin
                    shift_reg <= data_in; // Load data
                    gpio_out <= shift_reg;
                end
            end
            default: gpio_out <= 8'b00000000; // Default case (All low)
        endcase
    end
endmodule