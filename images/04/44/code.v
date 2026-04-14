module restoring_divider (
    input clk,
    input reset,
    input [4:0] dividend,
    input [2:0] divisor,
    output reg [4:0] quotient,
    output reg [1:0] remainder,
    output reg ready
);

reg [4:0] temp_dividend;
reg [2:0] temp_divisor;
reg [4:0] sub_result;
reg [2:0] count;
reg state; // 0: idle, 1: division in progress

always @(posedge clk or posedge reset) begin
    if (reset) begin
        quotient <= 5'b0;
        remainder <= 2'b0;
        temp_dividend <= 5'b0;
        temp_divisor <= 3'b0;
        count <= 3'b0;
        state <= 1'b0;
        ready <= 1'b0;
    end else if (state == 0) begin
        temp_dividend <= dividend;
        temp_divisor <= divisor;
        quotient <= 5'b0;
        count <= 3'b0;
        state <= 1'b1;
        ready <= 1'b0;
    end else if (count < 5) begin
        sub_result = temp_dividend - {2'b0, temp_divisor}; // subtract divisor shifted left
        if (sub_result[4] == 1'b0) begin
            temp_dividend <= sub_result; // update dividend if no borrow
            quotient[count] <= 1'b1; // set quotient bit
        end
        count <= count + 1;
    end else begin
        remainder <= temp_dividend[1:0]; // last 2 bits as remainder
        ready <= 1'b1; // indicate that division is done
        state <= 1'b0; // go back to idle
    end
end

endmodule