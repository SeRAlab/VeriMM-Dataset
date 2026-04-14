module branch_predictor(  
    input clk,  
    input reset,  
    input branch_taken,  
    output reg prediction  
);  
    reg [1:0] state; // 2-bit state representation  

    // State encoding  
    localparam ST_STRONG_TAKEN = 2'b11,  
               ST_WEAK_TAKEN = 2'b10,  
               ST_WEAK_NOT_TAKEN = 2'b01,  
               ST_STRONG_NOT_TAKEN = 2'b00;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= ST_STRONG_NOT_TAKEN;  
            prediction <= 0;  
        end else begin  
            case (state)  
                ST_STRONG_TAKEN: begin  
                    prediction <= 1;  
                    if (branch_taken)  
                        state <= ST_STRONG_TAKEN;  
                    else  
                        state <= ST_WEAK_TAKEN;  
                end  
                ST_WEAK_TAKEN: begin  
                    prediction <= 1;  
                    if (branch_taken)  
                        state <= ST_STRONG_TAKEN;  
                    else  
                        state <= ST_WEAK_NOT_TAKEN;  
                end  
                ST_WEAK_NOT_TAKEN: begin  
                    prediction <= 0;  
                    if (branch_taken)  
                        state <= ST_WEAK_TAKEN;  
                    else  
                        state <= ST_STRONG_NOT_TAKEN;  
                end  
                ST_STRONG_NOT_TAKEN: begin  
                    prediction <= 0;  
                    if (branch_taken)  
                        state <= ST_WEAK_NOT_TAKEN;  
                    else  
                        state <= ST_STRONG_NOT_TAKEN;  
                end  
            endcase  
        end  
    end  
endmodule