module branch_predictor(  
    input clk,  
    input reset,  
    input taken,  
    output reg [1:0] prediction  
);  
    reg [1:0] counter;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  
            prediction <= 2'b00;  
        end else begin  
            prediction <= counter;  
            case ({counter, taken})  
                3'b000: counter <= 2'b00; // 00 -> 00  
                3'b001: counter <= 2'b01; // 00 -> 01  
                3'b010: counter <= 2'b00; // 01 -> 00  
                3'b011: counter <= 2'b10; // 01 -> 10  
                3'b100: counter <= 2'b01; // 10 -> 01  
                3'b101: counter <= 2'b11; // 10 -> 11  
                3'b110: counter <= 2'b10; // 11 -> 10  
                3'b111: counter <= 2'b11; // 11 -> 11  
            endcase  
        end  
    end  
endmodule