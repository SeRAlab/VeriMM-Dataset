module top_module(
    input input1,
    input input2,
    input input3,
    input input4,
    input input5,
    input input6,
    input input7,
    input input8,
    output output1
);reg temp1, temp2, temp3, temp4, temp5, temp6;

    always @(*) begin
        if (input1 && input2) begin
            temp1 = 1;
        end else if (!input1 && input2) begin
            temp1 = 0;
        end else if (input1 && !input2) begin
            temp1 = 1;
        end else if (!input1 && !input2) begin
            if (!input3 && !input4 && !input5 && !input6 && !input7 && !input8) begin
                temp1 = 0;
            end else begin
                temp1 = 1;
            end
        end
    end

    assign output1 = temp1;

endmodule