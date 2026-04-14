module branch_predictor(  
    input clk,  
    input reset,  
    input branch_outcome,  
    output reg prediction  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00; // Start at Strongly Not Taken  
            prediction <= 1'b0;  
        end else begin  
            prediction <= counter[1]; // Output prediction based on MSB of counter  
            case (counter)  
                2'b00: if (branch_outcome) counter <= 2'b01; else counter <= 2'b00;  
                2'b01: if (branch_outcome) counter <= 2'b10; else counter <= 2'b00;  
                2'b10: if (branch_outcome) counter <= 2'b11; else counter <= 2'b01;  
                2'b11: if (branch_outcome) counter <= 2'b11; else counter <= 2'b10;  
                default: counter <= 2'b00;  
            endcase  
        end  
    end  
endmodule