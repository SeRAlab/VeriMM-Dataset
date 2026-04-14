module top_module(
    input src,
    input[31:0] input1,
    input[31:0] input2,
    output reg[31:0] outputResult
    );always@(src or input1 or input2)
    begin
        if(src == 0)
        begin
            outputResult <= input1;
        end
        else
        begin
            outputResult <= input2;
        end
    end
endmodule