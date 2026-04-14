module state_space_controller(  
    input clk,  
    input reset,  
    input [1:0] state_in,  
    output reg [1:0] control_out  
);  
    reg [1:0] current_state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_state <= 2'b00;  
        end else begin  
            current_state <= state_in;  
        end  
    end  

    always @(current_state) begin  
        case (current_state)  
            2'b00: control_out = 2'b01;  
            2'b01: control_out = 2'b10;  
            2'b10: control_out = 2'b11;  
            2'b11: control_out = 2'b00;  
            default: control_out = 2'b00;  
        endcase  
    end  
endmodule