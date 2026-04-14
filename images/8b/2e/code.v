module top_module(
    input clk,
    input [15:0] input_num,
    output reg [15:0] rounded_num  // Changed to reg
);reg [7:0] least_sig_bits;
    reg [15:0] temp_rounded_num;
    
    always @ (posedge clk) begin
        least_sig_bits = input_num[7:0];
        if (least_sig_bits == 8'b00000001) begin
            temp_rounded_num = input_num;
        end else if (least_sig_bits == 8'b00000010) begin
            temp_rounded_num = {input_num[15:8], 8'b00000010};
        end else if (least_sig_bits == 8'b00000100) begin
            temp_rounded_num = {input_num[15:8], 8'b00000100};
        end else if (least_sig_bits == 8'b00001000) begin
            temp_rounded_num = {input_num[15:8], 8'b00001000};
        end else if (least_sig_bits == 8'b00010000) begin
            temp_rounded_num = {input_num[15:8], 8'b00010000};
        end else if (least_sig_bits == 8'b00100000) begin
            temp_rounded_num = {input_num[15:8], 8'b00100000};
        end else if (least_sig_bits == 8'b01000000) begin
            temp_rounded_num = {input_num[15:8], 8'b01000000};
        end else if (least_sig_bits == 8'b10000000) begin
            temp_rounded_num = {input_num[15:8], 8'b10000000};
        end else begin
            temp_rounded_num = input_num; // Handle the case where none of the conditions are met
        end
        rounded_num <= temp_rounded_num; // Use non-blocking assignment

    end

endmodule