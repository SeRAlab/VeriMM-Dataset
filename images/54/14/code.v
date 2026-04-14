module top_module(
    input clk,
    input reset,      // Synchronous active-high reset for counter
    input enable,     // Enable input for counter
    input [7:0] A,    // 8-bit input A for division module
    input [7:0] B,    // 8-bit input B for division module
    output reg [7:0] quotient,    // 8-bit output for quotient from division module
    output reg [7:0] remainder,   // 8-bit output for remainder from division module
    output reg valid,            // Valid output for quotient and remainder values
    output reg [3:0] count,      // 4-bit output for current count value from counter
    output reg [7:0] final_out   // 8-bit output for sum of count and quotient
);reg [3:0] counter;     // 4-bit counter for counting clock cycles
reg [7:0] dividend;    // 8-bit dividend for division module
reg [7:0] divisor;     // 8-bit divisor for division module
reg [7:0] quotient_reg;    // 8-bit register for quotient value
reg [7:0] remainder_reg;   // 8-bit register for remainder value
reg valid_reg;         // Register for valid output
wire [7:0] sum;        // 8-bit wire for sum of count and quotient

// Binary counter with asynchronous reset and enable
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0;
    end else if (enable) begin
        count <= count + 1;
    end
end

// Division module
always @(*) begin
    dividend = A;
    divisor = B;
    if (divisor == 8'b0) begin
        quotient_reg = 8'b0;
        remainder_reg = 8'b0;
        valid_reg = 1'b0;
    end else begin
        quotient_reg = dividend / divisor;
        remainder_reg = dividend % divisor;
        valid_reg = 1'b1;
    end
end

// Final output module
assign sum = count + quotient_reg;
always @(posedge clk) begin
    final_out <= sum;
end

// Assign outputs
assign quotient = quotient_reg;
assign remainder = remainder_reg;
assign valid = valid_reg;

endmodule