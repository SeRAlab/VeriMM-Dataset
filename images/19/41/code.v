module branch_predictor(  
    input clk,  
    input reset,  
    input branch_taken,  
    output reg prediction  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b01; // Initial state (weakly taken)  
        end else begin  
            case (counter)  
                2'b00: begin  
                    prediction <= 1'b0; // Not taken  
                    if (branch_taken)  
                        counter <= 2'b01; // Move to weakly taken  
                end  
                2'b01: begin  
                    prediction <= 1'b0; // Not taken  
                    if (branch_taken)  
                        counter <= 2'b10; // Move to taken  
                    else  
                        counter <= 2'b00; // Move to strongly not taken  
                end  
                2'b10: begin  
                    prediction <= 1'b1; // Taken  
                    if (branch_taken)  
                        counter <= 2'b11; // Move to strongly taken  
                    else  
                        counter <= 2'b01; // Move to weakly taken  
                end  
                2'b11: begin  
                    prediction <= 1'b1; // Taken  
                    if (!branch_taken)  
                        counter <= 2'b10; // Move to taken  
                end  
            endcase  
        end  
    end  
endmodule