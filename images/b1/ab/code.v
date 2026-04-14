module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input d, // Input for the shift register
    output [3:0] q, // Output from the functional module
    output [2:0] shift_register // Output from the shift register
);reg [3:0] counter = 4'b0000;
    reg [2:0] shift_reg = 3'b000;
    reg [3:0] sum; // Changed from wire to reg

    // Counter module
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1;
        end
    end

    // Shift register module
    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], d};
    end

    // Functional module
    always @(posedge clk) begin
        sum <= counter + shift_reg; // Now valid since sum is a reg
    end

    assign q = sum;
    assign shift_register = shift_reg;

endmodule