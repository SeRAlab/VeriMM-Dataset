module branch_predictor(  
    input clk,  
    input reset,  
    input [1:0] branch_outcome,  // 00: not taken, 01: weakly not taken, 10: weakly taken, 11: taken  
    output reg prediction,  // 1: taken, 0: not taken  
    output reg [1:0] counter  // 2-bit saturating counter  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  // Initialize counter to 0  
            prediction <= 0;  
        end else begin  
            prediction <= (counter[1] == 1'b1);  // Predict taken if MSB of counter is 1  
            case (branch_outcome)  
                2'b00: counter <= (counter > 2'b00) ? counter - 1 : 2'b00;  // Not taken  
                2'b01: counter <= (counter > 2'b01) ? counter - 1 : 2'b01;  // Weakly not taken  
                2'b10: counter <= (counter < 2'b10) ? counter + 1 : 2'b10;  // Weakly taken  
                2'b11: counter <= (counter < 2'b11) ? counter + 1 : 2'b11;  // Taken  
                default: counter <= counter;  
            endcase  
        end  
    end  
endmodule