module deadbeat_controller(  
    input clk,  
    input reset,  
    input [3:0] current_state,  
    output reg [3:0] next_state  
);  
    reg [3:0] gain_matrix = 4'b1010; // Example gain matrix (for demonstration purposes)  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            next_state <= 4'b0000;  
        else  
            next_state <= current_state + gain_matrix; // Deadbeat control logic  
    end  
endmodule