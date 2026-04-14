module branch_predictor(  
    input clk,  
    input reset,  
    input branch_outcome,  
    output reg prediction  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  
            prediction <= 1'b0;  
        end else begin  
            prediction <= (counter[1] == 1'b1);  
            case (branch_outcome)  
                1'b0: counter <= counter + 1;  // Taken  
                1'b1: counter <= counter - 1;  // Not Taken  
            endcase  
        end  
    end  
endmodule