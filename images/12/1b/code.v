module branch_predictor(  
    input wire clk,  
    input wire reset,  
    input wire branch_taken,  
    output reg predicted_taken  
);  
    reg [1:0] counter; // 2-bit saturating counter  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b01; // Start with weakly taken  
            predicted_taken <= 1'b0;  
        end else begin  
            case (counter)  
                2'b00: begin // Strongly not taken  
                    predicted_taken <= 1'b0;  
                    if (branch_taken) counter <= 2'b01;  
                end  
                2'b01: begin // Weakly not taken  
                    predicted_taken <= 1'b0;  
                    if (branch_taken) counter <= 2'b10;  
                end  
                2'b10: begin // Weakly taken  
                    predicted_taken <= 1'b1;  
                    if (branch_taken) counter <= 2'b11;  
                    else counter <= 2'b01;  
                end  
                2'b11: begin // Strongly taken  
                    predicted_taken <= 1'b1;  
                    if (~branch_taken) counter <= 2'b10;  
                end  
            endcase  
        end  
    end  
endmodule