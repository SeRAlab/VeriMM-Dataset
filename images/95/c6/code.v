module top_module(
    input signed [7:0] dividend,
    input signed [7:0] divisor,
    input clk, // Added clk input
    output reg signed [7:0] quotient
);reg signed [7:0] remainder;
reg [2:0] state;

always @(posedge clk) begin
    case(state)
        0: begin // Fetch input data
            remainder <= dividend;
            quotient <= 0;
            state <= 1;
        end
        1: begin // Perform restoring algorithm
            if (remainder < 0) begin
                remainder <= remainder + divisor;
                quotient <= quotient << 1;
            end else begin
                remainder <= remainder - divisor;
                quotient <= (quotient << 1) | 1;
            end
            state <= 2;
        end
        2: begin // Write intermediate result to register
            // No operation needed, but retained for clarity
            remainder <= remainder;
            quotient <= quotient;
            state <= 3;
        end
        3: begin // Write final result to output register
            // No operation needed, but retained for clarity
            remainder <= remainder;
            quotient <= quotient;
            state <= 0;
        end
    endcase
end

endmodule