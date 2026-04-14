module divider (
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    input clk,
    input reset,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] part_dividend;
    reg [3:0] part_quotient;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0;
            remainder <= 4'b0;
            done <= 0;
            count <= 4'b0;
            part_dividend <= 4'b0;
            part_quotient <= 4'b0;
        end else if (start) begin
            if (count == 0) begin
                part_dividend <= dividend;
                part_quotient <= 0;
            end

            if (count < 4) begin
                if (part_dividend >= divisor) begin
                    part_dividend <= part_dividend - divisor;
                    part_quotient <= part_quotient + 1;
                end
                count <= count + 1;
            end else begin
                quotient <= part_quotient;
                remainder <= part_dividend;
                done <= 1;
            end
        end
    end
endmodule