module branch_predictor(  
    input clk,  
    input reset,  
    input taken,  
    output reg prediction  
);  
    reg [1:0] state;  
    parameter ST_STRONGLY_TAKEN = 2'b11;  
    parameter ST_WEAKLY_TAKEN = 2'b10;  
    parameter ST_WEAKLY_NOT_TAKEN = 2'b01;  
    parameter ST_STRONGLY_NOT_TAKEN = 2'b00;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= ST_STRONGLY_NOT_TAKEN;  
            prediction <= 0;  
        end else begin  
            prediction <= state[1];  
            case (state)  
                ST_STRONGLY_TAKEN: if (!taken) state <= ST_WEAKLY_TAKEN;  
                ST_WEAKLY_TAKEN: if (taken) state <= ST_STRONGLY_TAKEN; else state <= ST_WEAKLY_NOT_TAKEN;  
                ST_WEAKLY_NOT_TAKEN: if (taken) state <= ST_WEAKLY_TAKEN; else state <= ST_STRONGLY_NOT_TAKEN;  
                ST_STRONGLY_NOT_TAKEN: if (taken) state <= ST_WEAKLY_NOT_TAKEN;  
            endcase  
        end  
    end  
endmodule