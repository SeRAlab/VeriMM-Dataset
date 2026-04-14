module rnn_inference (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] x_in, // Input vector  
    input wire [7:0] h_prev, // Previous hidden state  
    output reg [7:0] h_out  // New hidden state  
);  
    // Weight matrices (example values for simplicity)  
    reg [7:0] w_ih [0:1];  
    reg [7:0] w_hh [0:1];  
    reg [7:0] weighted_input;  
    reg [7:0] weighted_hidden;  

    initial begin  
        w_ih[0] = 8'd2; // Weight for input  
        w_ih[1] = 8'd3; // Weight for input  
        w_hh[0] = 8'd1; // Weight for previous hidden state  
        w_hh[1] = 8'd4; // Weight for previous hidden state  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            h_out <= 8'd0;  
        end else begin  
            weighted_input = w_ih[0] * x_in[3:0] + w_ih[1] * x_in[7:4];  
            weighted_hidden = w_hh[0] * h_prev[3:0] + w_hh[1] * h_prev[7:4];  
            h_out <= (weighted_input + weighted_hidden) >> 1; // Simple averaging for activation  
        end  
    end  
endmodule