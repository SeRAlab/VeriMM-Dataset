module mpc_controller (  
    input clk,  
    input reset,  
    input [7:0] current_input,  
    output reg [7:0] next_output  
);  
    parameter GAIN = 8'h1A; // Example gain value (26 in decimal)  
    reg [7:0] previous_output;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            previous_output <= 8'b0;  
            next_output <= 8'b0;  
        end else begin  
            next_output <= (current_input * GAIN) / 255 + (previous_output * (255 - GAIN)) / 255;  
            previous_output <= next_output;  
        end  
    end  
endmodule