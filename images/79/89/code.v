module top_module( 
    input [7:0] input_num,
    output reg [7:0] final_output,
    output reg output_7,
    output reg output_6,
    output reg output_5,
    output reg output_4,
    output reg output_3,
    output reg output_2,
    output reg output_1,
    output reg output_0  
);assign output_7 = input_num[7];
    assign output_6 = input_num[6];
    assign output_5 = input_num[5];
    assign output_4 = input_num[4];
    assign output_3 = input_num[3];
    assign output_2 = input_num[2];
    assign output_1 = input_num[1];
    assign output_0 = input_num[0];
    
    always @ (input_num) begin
        final_output = input_num;
    end

endmodule