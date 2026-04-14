module DVFS_Controller(  
    input wire clk,  
    input wire reset,  
    input wire [1:0] workload, // 00: low, 01: medium, 10: high  
    output reg [1:0] freq_sel, // 00: low freq, 01: medium freq, 10: high freq  
    output reg [1:0] volt_sel  // 00: low volt, 01: medium volt, 10: high volt  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        freq_sel <= 2'b00;  
        volt_sel <= 2'b00;  
    end else begin  
        case (workload)  
            2'b00: begin // Low load  
                freq_sel <= 2'b00; // Low frequency  
                volt_sel <= 2'b00; // Low voltage  
            end  
            2'b01: begin // Medium load  
                freq_sel <= 2'b01; // Medium frequency  
                volt_sel <= 2'b01; // Medium voltage  
            end  
            2'b10: begin // High load  
                freq_sel <= 2'b10; // High frequency  
                volt_sel <= 2'b10; // High voltage  
            end  
            default: begin  
                freq_sel <= 2'b00;  
                volt_sel <= 2'b00;  
            end  
        endcase  
    end  
end  
endmodule