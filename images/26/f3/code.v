module branch_predictor(  
    input clk,  
    input reset,  
    input taken,  
    output reg prediction  
);  
    reg [1:0] counter;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            counter <= 2'b00;  
        else begin  
            case (counter)  
                2'b00: if (taken) counter <= 2'b01;  
                2'b01: if (taken) counter <= 2'b10; else counter <= 2'b00;  
                2'b10: if (taken) counter <= 2'b11; else counter <= 2'b01;  
                2'b11: if (taken) counter <= 2'b11; else counter <= 2'b10;  
            endcase  
        end  
    end  
  
    always @(*) begin  
        prediction = (counter >= 2'b10);  
    end  
endmodule