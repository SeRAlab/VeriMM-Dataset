module branch_predictor(  
    input clk,  
    input reset,  
    input actual_outcome,  
    output reg predicted_outcome  
);  
    reg [1:0] counter;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 1'b0;  
            predicted_outcome <= 1'b0;  
        end else begin  
            predicted_outcome <= counter[1]; // MSB for prediction  
            
            // Update counter based on actual outcome  
            if (predicted_outcome != actual_outcome) begin  
                // prediction was wrong, increment counter  
                counter <= (counter == 2'b11) ? 2'b11 : counter + 1;  
            end else begin  
                // prediction was right, decrement counter  
                counter <= (counter == 2'b00) ? 2'b00 : counter - 1;  
            end  
        end  
    end  
endmodule