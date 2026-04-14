module top_module(
    input clk,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);reg [7:0] dividend;
reg [7:0] divisor;
reg [7:0] quotient;
reg [7:0] remainder;
reg [3:0] count;
reg enable_division;

// Control logic module
always @ (posedge clk) begin
    if (enable_division) begin
        dividend <= a;
        divisor <= b;
        count <= 8;
    end
    if (count == 0) begin
        enable_division <= 0;
        out <= quotient;
    end
end

// Division module
always @ (posedge clk) begin
    if (enable_division) begin
        remainder <= dividend;
        if (remainder >= divisor) begin
            quotient[count-1] <= 1;
            remainder <= remainder - divisor;
        end
        else begin
            quotient[count-1] <= 0;
        end
        count <= count - 1;
        dividend <= remainder << 1;
    end
end

endmodule