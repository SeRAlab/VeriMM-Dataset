module divider_8bit (
    input wire clk,
    input wire start,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

reg [7:0] temp_dividend;
reg [7:0] temp_divisor;
reg [4:0] count; // 8-bit division requires at most 8 shifts
reg state; // 0: idle, 1: busy

always @(posedge clk) begin
    if (start) begin
        temp_dividend <= dividend;
        temp_divisor <= divisor;
        quotient <= 8'b0;
        remainder <= 8'b0;
        count <= 8;
        state <= 1; // set to busy
        done <= 0;
    end else if (state) begin
        if (count > 0) begin
            remainder <= {remainder[6:0], temp_dividend[7]};
            temp_dividend <= {temp_dividend[6:0], 1'b0};
            if (remainder >= temp_divisor) begin
                remainder <= remainder - temp_divisor;
                quotient <= {quotient[6:0], 1'b1};
            end else begin
                quotient <= {quotient[6:0], 1'b0};
            end
            count <= count - 1;
        end else begin
            state <= 0; // set back to idle
            done <= 1; // operation complete
        end
    end
end

endmodule