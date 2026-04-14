module state_space_controller(  
    input clk,  
    input reset,  
    input control,  
    output reg [1:0] state  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00; // Reset to State 0  
        end else begin  
            case (state)  
                2'b00: state <= control ? 2'b01 : 2'b00; // State 0  
                2'b01: state <= control ? 2'b10 : 2'b00; // State 1  
                2'b10: state <= control ? 2'b00 : 2'b01; // State 2  
                default: state <= 2'b00;  
            endcase  
        end  
    end  
endmodule