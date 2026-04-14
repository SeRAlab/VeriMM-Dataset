module neural_layer (  
    input clk,  
    input [7:0] in1,  
    input [7:0] in2,  
    input [7:0] in3,  
    output reg [15:0] out1,  
    output reg [15:0] out2  
);  
    reg [7:0] weights1 [0:2];  
    reg [7:0] weights2 [0:2];  
    integer i;  

    initial begin  
        weights1[0] = 8'd1;  
        weights1[1] = 8'd2;  
        weights1[2] = 8'd3;  
        weights2[0] = 8'd4;  
        weights2[1] = 8'd5;  
        weights2[2] = 8'd6;  
    end  

    always @(posedge clk) begin  
        out1 = 0;  
        out2 = 0;  
        for (i = 0; i < 3; i = i + 1) begin  
            out1 = out1 + in1 * weights1[i];  
            out2 = out2 + in2 * weights2[i];  
        end  
        out1 = out1 + in3;  
    end  
endmodule