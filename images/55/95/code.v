module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the shift register
    output [7:0] q,   // 8-bit output from the shift register
    output [3:0] add_out, // 4-bit output from the adder
    output reg [7:0] final_out // Changed to reg to make it a valid l-value
);reg [7:0] shift_reg;
    reg [3:0] counter;

    // Shift register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'h34;
        end else begin
            shift_reg <= {shift_reg[6:0], d};
        end
    end

    // 4-bit binary counter with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'h0;
        end else begin
            counter <= counter + 1;
        end
    end

    // 4-bit adder
    assign add_out = shift_reg[3:0] + counter;

    // Functional module to get final output
    always @(posedge clk) begin
        final_out <= shift_reg + add_out; // final_out can now be assigned 
    end

    // Output the shift register
    assign q = shift_reg;

endmodule