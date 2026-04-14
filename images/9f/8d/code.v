module top_module(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);wire p_1_0, g_1_0,p_3_2, g_3_2;
    assign p_1_0 = pin[0] & pin[1]; 
    assign g_1_0 = gin[1] | (pin[1] & gin[0]);
    assign cout[0] = gin[0] | (pin[0] & cin); 
    assign p_3_2 = pin[3] & pin[2];
    assign g_3_2 = gin[3] | (pin[3] & gin[2]);   

    
    wire p_3_0, g_3_0;
    assign p_3_0 = p_3_2 & p_1_0;
    assign g_3_0 = g_3_2 | (p_3_2 & g_1_0);
    assign cout[1] = g_1_0 | (p_1_0 & cin);
    
    assign cout[2] = gin[2] | (pin[2] & cout[1]);
    assign gout = g_3_0;
    assign pout = p_3_0;endmodule