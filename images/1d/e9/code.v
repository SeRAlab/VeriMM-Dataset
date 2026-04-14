module pipeline_adder (  
    input clk,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] sum  
);  
    reg [7:0] intermediate;  
  
    // Stage 1: Add inputs A and B  
    always @(posedge clk) begin  
        intermediate <= A + B;  
    end  
  
    // Stage 2: Output the intermediate result as sum  
    always @(posedge clk) begin  
        sum <= intermediate;  
    end  
endmodule