module branch_predictor(  
    input clk,  
    input reset,  
    input taken,  
    output reg prediction  
);  
    reg [0:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            counter <= 1'b0;  
        else begin  
            if (taken)  
                counter <= (counter == 1'b1) ? 1'b1 : counter + 1'b1;  
            else  
                counter <= (counter == 1'b0) ? 1'b0 : counter - 1'b1;  
        end  
    end  

    always @(*) begin  
        prediction = counter;  
    end  
endmodule