module dvfs_controller(  
    input wire clk,  
    input wire reset,  
    input wire [1:0] load,  
    output reg [1:0] frequency  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency <= 2'b00; // Low frequency  
        end else begin  
            case (load)  
                2'b00: frequency <= 2'b00; // Low load -> Low frequency  
                2'b01: frequency <= 2'b01; // Medium load -> Medium frequency  
                2'b10: frequency <= 2'b10; // High load -> High frequency  
                2'b11: frequency <= 2'b11; // Very high load -> Maximum frequency  
                default: frequency <= 2'b00;  
            endcase  
        end  
    end  
endmodule