module deadbeat_controller(  
    input clk,  
    input reset,  
    input [7:0] current_output,  
    output reg [7:0] control_signal  
);  
    parameter TARGET_OUTPUT = 8'd255; // Desired output  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 8'b0;  
        end else begin  
            control_signal <= TARGET_OUTPUT - current_output;  
        end  
    end  
endmodule