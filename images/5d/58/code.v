module top_module(
    input input1, 
    input input2, 
    input input3, 
    input input4, 
    input input5, 
    input input6, 
    input input7, 
    input input8, 
    output reg output1
);always @(*) begin
    if(input1 && input2) begin
        output1 = 1;
    end else if(!input3 && !input4) begin
        output1 = 0;
    end else if(input5 && input6 && input7) begin
        output1 = 1;
    end else begin
        output1 = input8;
    end
end

endmodule