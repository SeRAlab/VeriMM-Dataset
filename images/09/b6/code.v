module branch_predictor(  
    input clk,  
    input reset,  
    input branch_input,  
    output reg prediction  
);  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            prediction <= 0;  
        end else begin  
            prediction <= state[1];  
            case (state)  
                2'b00: if (branch_input) state <= 2'b01;  
                2'b01: if (branch_input) state <= 2'b10; else state <= 2'b00;  
                2'b10: if (branch_input) state <= 2'b11; else state <= 2'b01;  
                2'b11: if (~branch_input) state <= 2'b10;  
            endcase  
        end  
    end  
endmodule