module simple_rnn_cell(  
    input clk,  
    input rst,  
    input [7:0] x, // input value  
    input [7:0] h_in, // previous hidden state  
    output reg [7:0] h_out // new hidden state  
);  
    reg [7:0] weight = 8'd3; // hardcoded weight  
    reg [7:0] bias = 8'd1; // hardcoded bias  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            h_out <= 8'd0;  
        end else begin  
            h_out <= (weight * h_in + x) + bias;  
        end  
    end  
endmodule