module top_module(
    input clk,
    input reset,       // Synchronous active-high reset
    input [3:0] d,     // Input for the shift register
    input select,      // Select input to choose between shift register and counter
    output [7:0] q     // Output from the active module
);// Instantiate the 3-bit shift register from problem 1
    reg [2:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], d[0]}; // Shift in the least significant bit of d
        end
    end

    // Instantiate the 8-bit register from problem 2
    reg [7:0] reg_out;
    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 8'b0;
        end else if (select) begin
            reg_out <= reg_out + 1;
        end else begin
            reg_out <= {shift_reg, 5'b0};
        end
    end

    // Instantiate the functional module that takes in both the shift register and the register itself as inputs
    // and outputs the bitwise OR of the two inputs
    reg [7:0] or_out;
    always @* begin
        or_out = {5'b0, shift_reg} | reg_out; // Correctly align shift_reg to 8 bits
    end

    // Instantiate the control logic module that enables either the shift register or the counter based on a select input
    reg [7:0] active_out; // Change wire to reg
    always @* begin
        if (select) begin
            active_out = reg_out;
        end else begin
            active_out = or_out;
        end
    end

    // Assign the output to the active module's value
    assign q = active_out;

endmodule