module NVMe_Controller_Status_Register (  
    input wire clk,  
    input wire reset,  
    input wire ready,  
    input wire error,  
    input wire [2:0] operational_mode_in,  
    output reg ready_status,  
    output reg error_status,  
    output reg [2:0] operational_mode  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ready_status <= 0;  
            error_status <= 0;  
            operational_mode <= 3'b000; // Idle  
        end else begin  
            ready_status <= ready;  
            if (error) begin  
                error_status <= 1;  
                operational_mode <= 3'b000; // Reset to Idle  
            end else begin  
                error_status <= 0;  
                operational_mode <= operational_mode_in;  
            end  
        end  
    end  
endmodule