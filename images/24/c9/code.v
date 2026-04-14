module branch_predictor(  
    input clk,  
    input reset,  
    input branch_signal,  
    output reg prediction  
);  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b01; // Start in weakly taken state  
            prediction <= 1;  
        end else begin  
            case (state)  
                2'b00: begin // strongly not taken  
                    if (branch_signal) begin  
                        state <= 2'b01; // go to weakly taken  
                    end  
                    prediction <= 0;  
                end  
                2'b01: begin // weakly taken  
                    if (branch_signal) begin  
                        state <= 2'b10; // go to weakly taken  
                    end else begin  
                        state <= 2'b00; // go to strongly not taken  
                    end  
                    prediction <= 1;  
                end  
                2'b10: begin // weakly not taken  
                    if (branch_signal) begin  
                        state <= 2'b11; // go to strongly taken  
                    end else begin  
                        state <= 2'b01; // go to weakly taken  
                    end  
                    prediction <= 1;  
                end  
                2'b11: begin // strongly taken  
                    if (branch_signal) begin  
                        state <= 2'b11; // stay in strongly taken  
                    end else begin  
                        state <= 2'b10; // go to weakly taken  
                    end  
                    prediction <= 1;  
                end  
            endcase  
        end  
    end  
endmodule