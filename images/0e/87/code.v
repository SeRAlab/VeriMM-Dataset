module deadbeat_controller (  
    input clk,  
    input rst,  
    input [7:0] ref_input,  
    input [7:0] measured_output,  
    output reg [7:0] control_signal  
);  
  
    reg [7:0] error;  
    reg [2:0] state;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 3'b000;  
            control_signal <= 8'b00000000;  
        end else begin  
            error <= ref_input - measured_output;  
            case (state)  
                3'b000: begin  
                    control_signal <= error;  
                    state <= 3'b001;  
                end  
                3'b001: begin  
                    // Assume steady state reached after two clock cycles  
                    control_signal <= error;  
                    state <= 3'b010;  
                end  
                3'b010: begin  
                    control_signal <= 8'b00000000;  
                    state <= 3'b000; // Reset to initial state  
                end  
                default: state <= 3'b000;  
            endcase  
        end  
    end  
endmodule