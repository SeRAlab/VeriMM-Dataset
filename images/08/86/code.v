module LDO_Controller (  
    input wire clk,  
    input wire [7:0] Vin,    // Input voltage  
    input wire [7:0] Vref,   // Reference voltage  
    output reg [7:0] Vout    // Regulated output voltage  
);  
    reg [7:0] error;  
    reg [7:0] adjustment;  

    always @(posedge clk) begin  
        error <= Vref - Vin;  
        // Simple adjustment logic  
        if (error > 8'h00)  
            adjustment <= 8'h01;  
        else if (error < 8'h00)  
            adjustment <= -8'h01;  
        else  
            adjustment <= 8'h00;  

        Vout <= Vout + adjustment;  
    end  
endmodule