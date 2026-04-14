module branch_predictor(  
    input clk,  
    input reset,  
    input actual_outcome,  
    output reg prediction  
);  
    reg [1:0] state; // 2-bit state register  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00; // Initialize state  
            prediction <= 0;  
        end else begin  
            prediction <= state[1]; // Predict based on MSB of the state  

            // Update state based on actual outcome  
            case (state)  
                2'b00: state <= (actual_outcome) ? 2'b01 : 2'b00;  
                2'b01: state <= (actual_outcome) ? 2'b10 : 2'b00;  
                2'b10: state <= (actual_outcome) ? 2'b11 : 2'b01;  
                2'b11: state <= (actual_outcome) ? 2'b11 : 2'b10;  
            endcase  
        end  
    end  
endmodule