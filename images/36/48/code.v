module LDO_Regulator (  
    input wire clk,  
    input wire enable,  
    input wire [7:0] Vin,  
    output reg [7:0] Vout  
);  
    parameter REF_VOLTAGE = 8'd120; // 1.2V in some unit  
   
    always @(posedge clk) begin  
        if (enable) begin  
            if (Vin >= REF_VOLTAGE)  
                Vout <= REF_VOLTAGE;  
            else  
                Vout <= 8'd0;  
        end else begin  
            Vout <= 8'd0;  
        end  
    end  
endmodule