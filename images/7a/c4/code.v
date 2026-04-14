module top_module(
    input [15:0] data,
    input [3:0] shift_amount,
    output reg [15:0] shifted_data,
    input clk // Added clk input
);reg [15:0] shifted_data_reg1;
reg [15:0] shifted_data_reg2;
reg [15:0] shifted_data_reg3;

always @(*) begin
    shifted_data_reg1 = data << shift_amount;
end

always @(*) begin
    shifted_data_reg2 = shifted_data_reg1 << 1;
end

always @(*) begin
    shifted_data_reg3 = shifted_data_reg2 << 1;
end

always @(posedge clk) begin
    if (shift_amount > 15) begin
        shifted_data <= 0;
    end else begin
        shifted_data <= shifted_data_reg3;
    end
end

endmodule