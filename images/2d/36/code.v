module LDO_Regulator (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] Vin,  
    input wire control,  
    output reg [7:0] Vout  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        Vout <= 8'b0;  
    end else begin  
        if (control) begin  
            // Allow output to follow input  
            Vout <= Vin;  
        end else begin  
            // Regulate the output to a lower value (for simplicity, halve it)  
            Vout <= Vin >> 1;  
        end  
    end  
end  
endmodule