module branch_predictor(  
    input clk,  
    input reset,  
    input branch_outcome, // 1 for taken, 0 for not taken  
    output reg [1:0] prediction // 00: Strongly not taken, 01: Weakly not taken, 10: Weakly taken, 11: Strongly taken  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            prediction <= 2'b00; // Initialize to strongly not taken  
        end else begin  
            case (prediction)  
                2'b00: if (branch_outcome) prediction <= 2'b01;  
                2'b01: if (branch_outcome) prediction <= 2'b10; else prediction <= 2'b00;  
                2'b10: if (branch_outcome) prediction <= 2'b11; else prediction <= 2'b01;  
                2'b11: if (~branch_outcome) prediction <= 2'b10;  
            endcase  
        end  
    end  
endmodule