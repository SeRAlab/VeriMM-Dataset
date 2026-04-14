module top_module(
    input clk,
    input reset,            // Synchronous active-high reset
    input [3:0] d,          // 4-bit input for the shift register
    input enable,           // Active high enable for the shift register
    output [3:0] q,         // 4-bit output from the shift register
    output [3:0] counter_q, // 4-bit output from the binary counter
    output [7:0] sum        // 8-bit output from the functional module
);// Define the shift register
    reg [3:0] shift_reg;
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            shift_reg <= 4'b0;
        end else if (enable) begin
            shift_reg <= {shift_reg[2:0], d};
        end
    end
    assign q = shift_reg;

    // Define the binary counter
    reg [3:0] counter;
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            counter <= 4'b0;
        end else if (counter == 4'b1111) begin
            counter <= 4'b0;
        end else begin
            counter <= counter + 1;
        end
    end
    assign counter_q = counter;

    // Define the functional module that outputs the sum of the shift register and counter
    assign sum = {shift_reg, counter};

endmodule