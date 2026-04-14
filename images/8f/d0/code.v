module top_module(
    input [3:0] data,
    input [1:0] shift_amount,
    output reg [3:0] result
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    stage1_out = data << shift_amount;
end

always @(*) begin
    if (shift_amount == 2'b00) begin
        stage2_out = stage1_out;
    end else if (shift_amount == 2'b01) begin
        stage2_out = stage1_out[2:0];
    end else if (shift_amount == 2'b10) begin
        stage2_out = stage1_out[1:0];
    end else begin
        stage2_out = 4'b0000;
    end
end

assign result = stage2_out;

endmodule