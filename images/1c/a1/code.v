module restoring_divider (
    input [3:0] dividend,
    input [1:0] divisor,
    input clk,
    input rst,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    reg [3:0] temp_dividend;
    reg [1:0] count;
    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 2'b00;
            remainder <= 2'b00;
            temp_dividend <= 4'b0000;
            count <= 2'b00;
            state <= 1'b0;
        end else begin
            if (count < 2'b10) begin
                if (state == 0) begin
                    temp_dividend <= {temp_dividend[2:0], dividend[count]};
                    state <= 1'b1;
                end else begin
                    if (temp_dividend >= {2'b00, divisor}) begin
                        temp_dividend <= temp_dividend - {2'b00, divisor};
                        quotient <= {quotient[0], 1'b1};
                    end else begin
                        quotient <= {quotient[0], 1'b0};
                    end
                    count <= count + 1'b1;
                    state <= 1'b0;
                end
            end else begin
                remainder <= temp_dividend[1:0];
            end
        end
    end
endmodule