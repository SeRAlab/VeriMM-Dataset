module branch_predictor (  
    input wire clk,  
    input wire reset,  
    input wire taken,  
    output reg [1:0] prediction  
);  
    reg [1:0] counter;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00; // Start in the "not taken" state  
            prediction <= 2'b00;  
        end else begin  
            prediction <= counter;  
            if (taken) begin  
                if (counter < 2'b11)  
                    counter <= counter + 1;  
            end else begin  
                if (counter > 2'b00)  
                    counter <= counter - 1;  
            end  
        end  
    end  
endmodule