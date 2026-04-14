module branch_predictor(  
    input clk,  
    input rst,  
    input branch_taken,  
    output reg [1:0] state  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 2'b00; // reset to strongly not taken  
        end else begin  
            case (state)  
                2'b00: state <= branch_taken ? 2'b01 : 2'b00; // Strongly not taken  
                2'b01: state <= branch_taken ? 2'b10 : 2'b00; // Weakly not taken  
                2'b10: state <= branch_taken ? 2'b11 : 2'b01; // Weakly taken  
                2'b11: state <= branch_taken ? 2'b11 : 2'b10; // Strongly taken  
                default: state <= 2'b00;  
            endcase  
        end  
    end  
endmodule