module top_module(
    input CLK,
    input RESET,
    input DIR,
    input LOAD,
    input [15:0] D,
    input [15:0] V,
    output reg [15:0] Q,
    output reg [3:0] R
);reg [3:0] count;
reg [15:0] dividend_reg;
reg [15:0] divisor_reg;
reg [15:0] quotient_reg;
reg [3:0] remainder_reg;

// Up/Down Counter
always @(posedge CLK) begin
    if (RESET) begin
        count <= 0;
    end else if (LOAD) begin
        count <= D[3:0];
    end else if (DIR == 0) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

// 16-bit Unsigned Division
always @(posedge CLK) begin
    if (RESET) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient_reg <= 0;
        remainder_reg <= 0;
    end else begin
        dividend_reg <= D;
        divisor_reg <= V;
        quotient_reg <= dividend_reg / divisor_reg;
        remainder_reg <= dividend_reg % divisor_reg;
    end
end

// Final Result Module
always @(posedge CLK) begin
    if (RESET) begin
        Q <= 0;
        R <= 0;
    end else begin
        Q <= quotient_reg + count;
        R <= remainder_reg;
    end
end

endmodule