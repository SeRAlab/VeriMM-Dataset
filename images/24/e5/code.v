module power_gating_controller(  
    input wire ctrl,  
    input wire pd,  
    output wire gated_pd  
);  
    assign gated_pd = ctrl && pd;  
endmodule