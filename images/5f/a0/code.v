module top_module(
    input [3:0] data,
    input [1:0] shift_amount,
    output reg [3:0] result
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    case(shift_amount)
        2'b00: stage1_out = data;
        2'b01: stage1_out = {data[2:0], 1'b0};
        2'b10: stage1_out = {data[1:0], 2'b00};
        2'b11: stage1_out = {data[0], 3'b000};
    endcase
end

always @(*) begin
    case(shift_amount)
        2'b00: stage2_out = stage1_out;
        2'b01: stage2_out = {stage1_out[1:0], data[3]};
        2'b10: stage2_out = {stage1_out[2:0], data[3:2]};
        2'b11: stage2_out = {stage1_out[3], data[3:1]};
    endcase
end

assign result = stage2_out;

endmodule