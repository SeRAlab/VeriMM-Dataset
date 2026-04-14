module branch_predictor(  
    input clk,  
    input reset,  
    input branch_outcome,  
    output reg prediction  
);  
    reg [1:0] state; // 00: Strongly Not Taken, 01: Weakly Not Taken, 10: Weakly Taken, 11: Strongly Taken  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00; // Reset to Strongly Not Taken  
        end else begin  
            case (state)  
                2'b00: begin // Strongly Not Taken  
                    prediction <= 0;  
                    if (branch_outcome) state <= 2'b01;  
                end  
                2'b01: begin // Weakly Not Taken  
                    prediction <= 0;  
                    if (branch_outcome) state <= 2'b10;  
                    else state <= 2'b00;  
                end  
                2'b10: begin // Weakly Taken  
                    prediction <= 1;  
                    if (branch_outcome) state <= 2'b11;  
                    else state <= 2'b01;  
                end  
                2'b11: begin // Strongly Taken  
                    prediction <= 1;  
                    if (branch_outcome) state <= 2'b11;  
                    else state <= 2'b10;  
                end  
            endcase  
        end  
    end  
endmodule