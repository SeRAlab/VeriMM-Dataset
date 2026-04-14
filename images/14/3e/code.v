module SRAM_16bit (  
    input wire clk,  
    input wire reset,  
    input wire wen, // Write Enable  
    input wire ren, // Read Enable  
    input wire [15:0] din, // Data Input  
    output reg [15:0] dout // Data Output  
);  
    reg [15:0] sram; // 16-bit SRAM storage  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sram <= 16'b0; // Initialize SRAM to zero  
            dout <= 16'b0; // Initialize output to zero  
        end else begin  
            if (wen) begin  
                sram <= din; // Write data to SRAM  
            end  
            if (ren) begin  
                dout <= sram; // Read data from SRAM  
            end  
        end  
    end  
endmodule