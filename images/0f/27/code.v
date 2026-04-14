module deadbeat_controller(  
    input clk,  
    input reset,  
    input [7:0] ref_input,  
    output reg [7:0] control_signal  
);  
    reg [7:0] previous_output;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 8'b0;  
            previous_output <= 8'b0;  
        end else begin  
            control_signal <= ref_input;  
            previous_output <= control_signal;  
        end  
    end  
endmodule