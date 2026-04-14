module deadbeat_controller (  
    input clk,  
    input reset,  
    input [3:0] x,  
    output reg [3:0] u  
);  

    // Define the gain matrix for the deadbeat controller
    reg [3:0] gain_matrix [0:3]; // Assuming a 4x4 gain matrix for a 4-bit input  
    initial begin  
        gain_matrix[0] = 4'b0001;  
        gain_matrix[1] = 4'b0010;  
        gain_matrix[2] = 4'b0100;  
        gain_matrix[3] = 4'b1000;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            u <= 4'b0000;  
        else  
            u <= gain_matrix[x[3:2]] & x; // Example operation for deadbeat control  
    end  
endmodule