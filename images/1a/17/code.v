module non_restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    input clk,
    input reset,
    output reg [7:0] quotient,
    output reg remainder,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 8'b0;
            quotient <= 8'b0;
            remainder <= 1'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (start) begin
            if (divisor == 0) begin
                quotient <= 8'b0;
                remainder <= dividend;
                done <= 1'b1;
            end else if (count < 8) begin
                A <= {A[6:0], dividend[count]};
                count <= count + 1;
                
                if (A >= divisor) begin
                    A <= A - divisor;
                    quotient[count] <= 1'b1;
                end else begin
                    quotient[count] <= 1'b0;
                end

                if (count == 7) begin
                    remainder <= A;
                    done <= 1'b1;
                end
            end
        end
    end
endmodule