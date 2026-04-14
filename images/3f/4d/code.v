module divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    input start
);
    reg [7:0] divd, divr;
    reg [7:0] q;
    reg [3:0] count;
    reg busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            divd <= 8'b0;
            divr <= 8'b0;
            q <= 8'b0;
            count <= 4'b0;
            busy <= 1'b0;
        end else if (start && !busy) begin
            divd <= dividend;
            divr <= divisor;
            q <= 8'b0;
            count <= 4'b1000; // Start with 8 bits
            busy <= 1'b1;

            if (divisor == 8'b0) begin
                quotient <= 8'b0;
                remainder <= 8'b0;
                busy <= 1'b0;
            end
        end else if (busy) begin
            if (count > 0) begin
                q = {q[6:0], divd[7]};
                divd = {divd[6:0], 1'b0}; // Shift left
                if (q >= divr) begin
                    q = q - divr;
                    quotient = {quotient[6:0], 1'b1}; // Set bit in quotient
                end else begin
                    quotient = {quotient[6:0], 1'b0}; // Clear bit in quotient
                end
                count = count - 1;
            end else begin
                remainder <= q;
                busy <= 1'b0;
            end
        end
    end
endmodule