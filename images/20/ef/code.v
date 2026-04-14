module branch_predictor(  
    input clk,  
    input reset,  
    input branch_out,  
    output reg prediction  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  
            prediction <= 1'b0;  
        end else begin  
            case (counter)  
                2'b00: begin  
                    if (branch_out) begin  
                        counter <= 2'b01;  
                        prediction <= 1'b0;  
                    end  
                end  
                2'b01: begin  
                    if (branch_out) begin  
                        counter <= 2'b10;  
                        prediction <= 1'b1;  
                    end else begin  
                        counter <= 2'b00;  
                        prediction <= 1'b0;  
                    end  
                end  
                2'b10: begin  
                    if (branch_out) begin  
                        counter <= 2'b11;  
                        prediction <= 1'b1;  
                    end else begin  
                        counter <= 2'b01;  
                        prediction <= 1'b1;  
                    end  
                end  
                2'b11: begin  
                    if (branch_out) begin  
                        counter <= 2'b11;  
                        prediction <= 1'b1;  
                    end else begin  
                        counter <= 2'b10;  
                        prediction <= 1'b1;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule