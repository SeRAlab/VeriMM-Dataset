module power_gating(input wire ctrl, input wire dev_in, output wire dev_out);  
    assign dev_out = ctrl ? dev_in : 1'b0;  
endmodule