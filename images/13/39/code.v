module divider_4bit (
    input wire clk,
    input wire rst,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            valid <= 1'b0;
            count <= 4'b0000;
        end else begin
            if (count < 4) begin
                temp_dividend <= {remainder, dividend[count]};
                if (temp_dividend >= divisor) begin
                    temp_dividend <= temp_dividend - divisor;
                    temp_quotient[count] <= 1'b1;
                end else begin
                    temp_quotient[count] <= 1'b0;
                end
                remainder <= temp_dividend;
                count <= count + 1;
            end else begin
                quotient <= temp_quotient;
                valid <= 1'b1;
            end
        end
    end
endmodule