module median_filter_3x3(  
    input [2:0] in00,  
    input [2:0] in01,  
    input [2:0] in02,  
    input [2:0] in10,  
    input [2:0] in11,  
    input [2:0] in12,  
    input [2:0] in20,  
    input [2:0] in21,  
    input [2:0] in22,  
    output reg [2:0] median  
);  

reg [2:0] values [0:8];  
integer i, j;  

always @(*) begin  
    // Collect all inputs into an array  
    values[0] = in00;  
    values[1] = in01;  
    values[2] = in02;  
    values[3] = in10;  
    values[4] = in11;  
    values[5] = in12;  
    values[6] = in20;  
    values[7] = in21;  
    values[8] = in22;  

    // Sort the values  
    for (i = 0; i < 9; i = i + 1) begin  
        for (j = i + 1; j < 9; j = j + 1) begin  
            if (values[i] > values[j]) begin  
                {values[i], values[j]} = {values[j], values[i]};  
            end  
        end  
    end  

    // The median is the 5th element in the sorted array  
    median = values[4];  
end  
endmodule