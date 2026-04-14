module top_module(
    input resetn_2b,
    input clk_2b,
    input[31:0] source_number_2b_0,
    input[1:0] source_number_2b_1,

    output reg[63:0] result_2b
);always@(posedge clk_2b) begin
    if(resetn_2b == 0) begin
        result_2b <= 0;
    end
    else begin
        if(source_number_2b_1 == 0) begin
            result_2b <= 0;
        end
        else if (source_number_2b_1 == 1) begin
            result_2b <= source_number_2b_0;
        end
        else if (source_number_2b_1 == 2) begin
            result_2b <= source_number_2b_0 << 1;           
        end
        else if (source_number_2b_1 == 3) begin
            result_2b <= (source_number_2b_0 << 1) + source_number_2b_0;     
        end
        else begin
            result_2b <= 0;
        end
    end
end

endmodule