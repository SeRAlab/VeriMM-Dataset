module top_module(
    input [15:0] data,
    input [3:0] shift_amount,
    output [15:0] shifted_data
);reg [15:0] stage1_data;
reg [15:0] stage2_data;
reg [15:0] stage3_data;
reg [15:0] stage4_data;

always @(data, shift_amount) begin
    stage1_data <= data;
    stage2_data <= stage1_data >> 1;
    stage3_data <= stage2_data >> 2;
    stage4_data <= stage3_data >> 4;
end

assign shifted_data = (shift_amount == 4'b0000) ? stage4_data :
                      (shift_amount == 4'b0001) ? {stage4_data[14:0], 1'b0} :
                      (shift_amount == 4'b0010) ? {stage4_data[13:0], 2'b00} :
                      (shift_amount == 4'b0011) ? {stage4_data[12:0], 3'b000} :
                      (shift_amount == 4'b0100) ? {stage4_data[11:0], 4'b0000} :
                      (shift_amount == 4'b0101) ? {stage4_data[10:0], 5'b00000} :
                      (shift_amount == 4'b0110) ? {stage4_data[9:0], 6'b000000} :
                      (shift_amount == 4'b0111) ? {stage4_data[8:0], 7'b0000000} :
                      (shift_amount == 4'b1000) ? {stage4_data[7:0], 8'b00000000} :
                      (shift_amount == 4'b1001) ? {stage4_data[6:0], 9'b000000000} :
                      (shift_amount == 4'b1010) ? {stage4_data[5:0], 10'b0000000000} :
                      (shift_amount == 4'b1011) ? {stage4_data[4:0], 11'b00000000000} :
                      (shift_amount == 4'b1100) ? {stage4_data[3:0], 12'b000000000000} :
                      (shift_amount == 4'b1101) ? {stage4_data[2:0], 13'b0000000000000} :
                      (shift_amount == 4'b1110) ? {stage4_data[1:0], 14'b00000000000000} :
                      (shift_amount == 4'b1111) ? {stage4_data[0], 15'b000000000000000} : 
                      16'b0;

endmodule