module top_module(
    input clk,
    input [7:0] d,
    output reg [7:0] average
);reg [7:0] shift_reg [0:7];
integer i;
reg [11:0] sum;

always @(posedge clk) begin
    // Shift the input data into the shift register
    for (i = 7; i > 0; i = i - 1) begin
        shift_reg[i] <= shift_reg[i - 1];
    end
    shift_reg[0] <= d;

    // Calculate the sum using half adders
    sum <= 0;
    for (i = 0; i < 8; i = i + 1) begin
        sum <= sum + shift_reg[i];
    end

    // Calculate the average
    average <= sum >> 3;
end

endmodule