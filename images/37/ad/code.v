module LDO_Regulator (  
    input wire [7:0] V_ref,    // Reference voltage  
    input wire [7:0] V_in,     // Input voltage  
    output reg [7:0] V_out     // Output voltage  
);  
    always @(*) begin  
        if (V_in >= V_ref) begin  
            V_out = V_ref;  
        end else begin  
            V_out = V_in;  
        end  
    end  
endmodule