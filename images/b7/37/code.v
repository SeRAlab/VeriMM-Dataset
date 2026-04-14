module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input select,     // Select input to choose between adders
    input [3:0] a,    // 4-bit input for the first adder
    input [3:0] b,    // 4-bit input for the first adder and the second adder
    output reg [3:0] sum  // 4-bit output from the active adder (changed to reg type)
);reg [3:0] sum1, sum2;  // Internal registers to store the outputs of the adders

// First 4-bit adder with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        sum1 <= 4'b0;
    end else begin
        sum1 <= a + b;
    end
end

// Second 4-bit adder with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        sum2 <= 4'b0;
    end else begin
        sum2 <= sum1 + b;
    end
end

// Control logic to select the active adder
always @(posedge clk) begin
    if (reset) begin
        sum <= 4'b0;
    end else begin
        if (select) begin
            sum <= sum2;
        end else begin
            sum <= sum1;
        end
    end
end

endmodule