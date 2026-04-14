module rnn_cell(  
    input clk,  
    input reset,  
    input [15:0] x1,  
    input [15:0] x2,  
    output reg [15:0] y1,  
    output reg [15:0] y2  
);  
    reg [15:0] h1, h2;  
    reg [15:0] W_xh1 = 16'h2; // Weight for x1  
    reg [15:0] W_xh2 = 16'h3; // Weight for x2  
    reg [15:0] W_hh1 = 16'h1; // Weight for h1  
    reg [15:0] W_hh2 = 16'h1; // Weight for h2  
    reg [15:0] W_hy1 = 16'h4; // Weight for output y1  
    reg [15:0] W_hy2 = 16'h5; // Weight for output y2  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            h1 <= 16'h0;  
            h2 <= 16'h0;  
            y1 <= 16'h0;  
            y2 <= 16'h0;  
        end else begin  
            h1 <= $signed((W_hh1 * h1) + (W_xh1 * x1));  
            h2 <= $signed((W_hh2 * h2) + (W_xh2 * x2));  
            y1 <= W_hy1 * h1;  
            y2 <= W_hy2 * h2;  
        end  
    end  
endmodule