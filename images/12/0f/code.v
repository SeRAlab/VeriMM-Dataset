module deadbeat_controller(clk, reset, error, control_signal);  
    input clk;  
    input reset;  
    input [3:0] error;  
    output reg [3:0] control_signal;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 4'b0000;  
        end else begin  
            case (error)  
                4'b0000: control_signal <= 4'b0000;  
                4'b0001: control_signal <= 4'b0001;  
                4'b0010: control_signal <= 4'b0010;  
                4'b0011: control_signal <= 4'b0011;  
                4'b0100: control_signal <= 4'b0100;  
                default: control_signal <= 4'b1111;  
            endcase  
        end  
    end  
endmodule