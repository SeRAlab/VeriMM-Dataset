module branch_predictor(  
    input clk,  
    input reset,  
    input taken,  
    output reg prediction  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            counter <= 2'b00;  
        else begin  
            if (taken)  
                counter <= (counter == 2'b11) ? 2'b11 : counter + 1;  
            else  
                counter <= (counter == 2'b00) ? 2'b00 : counter - 1;  
        end  
    end  

    always @(*) begin  
        prediction = (counter[1] == 1'b1);  
    end  
endmodule