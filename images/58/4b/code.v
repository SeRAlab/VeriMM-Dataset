module top_module(
    output reg [1:0] Q,
    output reg D,
    output reg DI,
    output reg UNDRFLW_FLAG_FRMT,
    output reg OVRFLW_FLAG_FRMT,
    input [0:0] Q_reg_1_0,
    input [2:0] Q_reg_2_0,
    input CLK,
    input [0:0] AR
);wire [2:0] sum;
    assign sum = Q_reg_1_0 + Q_reg_2_0;

    always @(posedge CLK) begin
        if (AR) begin
            Q <= 2'b00;
            D <= 1'b0;
            DI <= 1'b1;
            OVRFLW_FLAG_FRMT <= 1'b0;
            UNDRFLW_FLAG_FRMT <= 1'b0;
        end else begin
            Q <= sum[1:0];
            D <= (sum[1] == 1);
            DI <= (sum == 0);
            OVRFLW_FLAG_FRMT <= (sum > 2);
            UNDRFLW_FLAG_FRMT <= (sum < 0);
        end
    end

endmodule