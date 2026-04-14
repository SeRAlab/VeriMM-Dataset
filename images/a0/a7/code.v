module top_module(
    input clk,
    input rst_n,
    input [7:0] A,
    input [7:0] B,
    input ready,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg valid
);reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient_reg;
reg [7:0] remainder_reg;
reg [2:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        quotient_reg <= 8'b0;
        remainder_reg <= 8'b0;
        state <= 3'b000;
        valid <= 1'b0;
    end else begin
        case (state)
            3'b000: begin
                dividend_reg <= A;
                divisor_reg <= B;
                state <= 3'b001;
            end
            3'b001: begin
                if (divisor_reg == 8'b0) begin
                    quotient_reg <= 8'b0;
                    remainder_reg <= 8'b0;
                    state <= 3'b000;
                    valid <= 1'b1;
                end else begin
                    quotient_reg <= dividend_reg / divisor_reg;
                    remainder_reg <= dividend_reg % divisor_reg;
                    state <= 3'b010;
                end
            end
            3'b010: begin
                if (ready) begin
                    state <= 3'b011;
                end
            end
            3'b011: begin
                quotient <= quotient_reg;
                remainder <= remainder_reg;
                valid <= 1'b1;
                state <= 3'b000;
            end
        endcase
    end
end

endmodule