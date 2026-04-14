module vco (  
    input [3:0] voltage,  // 4-bit input voltage value  
    input clk,           // Base clock input  
    output reg vco_out   // VCO output signal  
);  
    parameter K = 2; // Constant to scale the frequency  
    reg [31:0] count; // Counter to generate the frequency  
    reg [31:0] threshold; // Threshold for toggling the output based on voltage  

    always @(posedge clk) begin  
        threshold <= K * voltage;  
        count <= count + 1;  
        if (count >= threshold) begin  
            count <= 0;  
            vco_out <= ~vco_out;  
        end  
    end  
endmodule