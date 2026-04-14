module top_module(
    input clk,
    input load,
    input select,
    input signed [3:0] dividend,
    input signed [3:0] divisor,
    input signed [3:0] serial_in,
    output reg signed [3:0] quotient,
    output reg signed [3:0] remainder
);reg signed [3:0] shift_reg [2:0];
reg signed [3:0] temp_dividend;
reg signed [3:0] temp_remainder;
reg signed [3:0] temp_quotient;
reg signed [3:0] neg_divisor;
reg signed [3:0] shifted_divisor;
reg signed [3:0] shifted_remainder;
reg signed [3:0] shifted_quotient;
reg signed [1:0] count;
reg signed [1:0] i;

assign shifted_divisor = {divisor, 2'b0};
assign shifted_remainder = {shift_reg[2], shift_reg[1], shift_reg[0]};
assign shifted_quotient = {temp_quotient, 1'b0};

always @(posedge clk) begin
    if (load) begin
        shift_reg[2] <= dividend;
        shift_reg[1] <= 0;
        shift_reg[0] <= 0;
        quotient <= 0;
        remainder <= 0;
        count <= 0;
    end else begin
        shift_reg[2] <= shift_reg[1];
        shift_reg[1] <= shift_reg[0];
        shift_reg[0] <= serial_in;
        temp_dividend <= {shift_reg[2], shift_reg[1], shift_reg[0]};
        neg_divisor <= -divisor;
        if (count == 2'b00) begin
            temp_remainder <= temp_dividend;
            temp_quotient <= 0;
        end else begin
            if (temp_remainder[3] == 1) begin
                temp_remainder <= temp_remainder + shifted_divisor;
                temp_quotient <= shifted_quotient + 1;
            end else begin
                temp_remainder <= temp_remainder - shifted_divisor;
                temp_quotient <= shifted_quotient;
            end
        end
        count <= count + 1;
        if (count == 2'b11) begin
            count <= 0;
            if (select) begin
                quotient <= temp_quotient;
            end else begin
                remainder <= temp_remainder;
            end
        end
    end
end

endmodule