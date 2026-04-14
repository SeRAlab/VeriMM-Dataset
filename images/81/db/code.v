module top_module(
    input_1,
    input_2,
    input_3,
    input_4,
    input_5,
    input_6,
    input_7,
    input_8,
    output_1
);input [3:0] input_1;
    input [1:0] input_2;
    input input_3;
    input input_4;
    input input_5;
    input input_6;
    input input_7;
    input input_8;
    output reg output_1;
    
    always @ (input_1 or input_2 or input_3 or input_4 or input_5 or input_6 or input_7 or input_8) begin
        case (input_1)
            0: output_1 = 0;
            1: output_1 = input_3;
            2: output_1 = input_4;
            3: output_1 = input_5;
            4: output_1 = input_6;
            5: output_1 = input_7;
            6: output_1 = input_8;
            7: output_1 = input_2;
            default: output_1 = 0;
        endcase
    end
endmodule