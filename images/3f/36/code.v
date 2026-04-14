module branch_predictor(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] branch_addr,  
    input wire actual_outcome,  
    output reg predicted_outcome  
);  

    reg [1:0] predictor_table [0:15]; // 16 entries for 2-bit counter  

    // Initial states of the predictors  
    integer i;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 16; i = i + 1) begin  
                predictor_table[i] <= 2'b00; // Initialize all to 00 (strongly not taken)  
            end  
        end else begin  
            // Update the predicted outcome  
            predicted_outcome <= (predictor_table[branch_addr] >= 2'b10);  

            // Update the 2-bit counter based on actual outcome  
            if (actual_outcome) begin  
                // If taken, increment the counter (with saturation)  
                if (predictor_table[branch_addr] < 2'b11)  
                    predictor_table[branch_addr] <= predictor_table[branch_addr] + 1;  
            end else begin  
                // If not taken, decrement the counter (with saturation)  
                if (predictor_table[branch_addr] > 2'b00)  
                    predictor_table[branch_addr] <= predictor_table[branch_addr] - 1;  
            end  
        end  
    end  
endmodule