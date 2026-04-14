module power_gating(input wire power_request, input wire enable, output wire power_gate);  
    assign power_gate = power_request & enable;  
endmodule