module deadbeat_controller(  
    input clk,  
    input reset,  
    input [3:0] reference,  
    input [3:0] current_output,  
    output reg [3:0] control_signal  
);  
    reg [3:0] error;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 4'b0000;  
        end else begin  
            error <= reference - current_output;  
            control_signal <= error;  
        end  
    end  
endmodule