module power_gating(input wire enable,  
                    input wire power,  
                    output wire power_out);  
    assign power_out = enable ? power : 1'b0;  
endmodule