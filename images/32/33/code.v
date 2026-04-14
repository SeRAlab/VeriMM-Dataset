module branch_predictor (  
    input clk,  
    input rst,  
    input taken,  
    output reg prediction  
);  
    reg [1:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= 2'b00; // Reset to strongly not taken  
        else begin  
            case (state)  
                2'b00: state <= (taken) ? 2'b01 : 2'b00; // Strongly not taken  
                2'b01: state <= (taken) ? 2'b10 : 2'b00; // Weakly not taken  
                2'b10: state <= (taken) ? 2'b11 : 2'b01; // Weakly taken  
                2'b11: state <= (taken) ? 2'b11 : 2'b10; // Strongly taken  
            endcase  
        end  
    end  

    always @(state) begin  
        case (state)  
            2'b00, 2'b01: prediction = 1'b0; // Not taken  
            2'b10, 2'b11: prediction = 1'b1; // Taken  
        endcase  
    end  
endmodule