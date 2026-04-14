module top_module(
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient
);reg [15:0] remainder;
reg [15:0] neg_divisor;
reg [1:0] state;

always @(*) begin
    case(state)
        2'b00: begin // Fetch inputs
            remainder <= dividend;
            neg_divisor <= ~divisor + 1;
            state <= 2'b01;
        end
        2'b01: begin // Division calculation
            if (remainder[15] == 1) begin
                remainder <= (remainder << 1) | 1;
                quotient <= quotient << 1;
            end else begin
                remainder <= remainder << 1;
                quotient <= quotient << 1;
            end
            if (remainder >= 0) begin
                remainder <= remainder + neg_divisor;
                quotient[0] <= 1;
            end else begin
                quotient[0] <= 0;
            end
            state <= 2'b10;
        end
        2'b10: begin // Write result to output register
            if (state == 2'b10) begin
                state <= 2'b00;
            end
        end
    endcase
end

endmodule