module top_module(
    input [3:0] input_1,
    input [1:0] input_2,
    input [2:0] input_3,
    input input_4,
    input [1:0] input_5,
    input input_6,
    output reg output_1
);always @(*) begin
        if (input_1 <= 7) begin
            output_1 = 1;
        end else begin
            output_1 = 0;
        end
        
        if (input_2 == 1 || input_2 == 3) begin
            output_1 = 0;
        end
        
        if (input_3 >= 4 && input_4 == 1) begin
            output_1 = 0;
        end
        
        if (input_5 == 2 && input_6 == 0) begin
            output_1 = 0;
        end
    end

endmodule