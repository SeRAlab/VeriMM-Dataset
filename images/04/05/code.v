module robot_movement(  
    input clk,  
    input reset,  
    input [1:0] direction,  
    output reg [1:0] state  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= 2'b00; // Initial state (Moving Up)  
        else begin  
            case (direction)  
                2'b00: state <= 2'b00; // Moving Up  
                2'b01: state <= 2'b01; // Moving Down  
                2'b10: state <= 2'b10; // Moving Left  
                2'b11: state <= 2'b11; // Moving Right  
                default: state <= state; // Retain current state  
            endcase  
        end  
    end  
endmodule