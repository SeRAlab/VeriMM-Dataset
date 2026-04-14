module branch_predictor(  
    input wire clk,  
    input wire reset,  
    input wire branch_taken,  
    output reg [1:0] prediction  
);  
    // State encoding  
    parameter STRONGLY_NOT_TAKEN = 2'b00;  
    parameter WEAKLY_NOT_TAKEN = 2'b01;  
    parameter WEAKLY_TAKEN = 2'b10;  
    parameter STRONGLY_TAKEN = 2'b11;  
    
    // Initial state  
    initial begin  
        prediction = STRONGLY_NOT_TAKEN;  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            prediction <= STRONGLY_NOT_TAKEN;  
        end else begin  
            case (prediction)  
                STRONGLY_NOT_TAKEN: begin  
                    if (branch_taken)  
                        prediction <= WEAKLY_NOT_TAKEN;  
                end  
                WEAKLY_NOT_TAKEN: begin  
                    if (branch_taken)  
                        prediction <= WEAKLY_TAKEN;  
                    else  
                        prediction <= STRONGLY_NOT_TAKEN;  
                end  
                WEAKLY_TAKEN: begin  
                    if (branch_taken)  
                        prediction <= STRONGLY_TAKEN;  
                    else  
                        prediction <= WEAKLY_NOT_TAKEN;  
                end  
                STRONGLY_TAKEN: begin  
                    if (!branch_taken)  
                        prediction <= WEAKLY_TAKEN;  
                end  
            endcase  
        end  
    end  
endmodule