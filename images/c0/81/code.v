module bus_switch
(
    input wire ctl_sw_1u,               
    input wire ctl_sw_1d,               
    input wire ctl_sw_2u,               
    input wire ctl_sw_2d,               
    input wire ctl_sw_mask543_en,       
    output wire bus_sw_1u,              
    output wire bus_sw_1d,              
    output wire bus_sw_2u,              
    output wire bus_sw_2d,              
    output wire bus_sw_mask543_en       
);
assign bus_sw_1u = ctl_sw_1u;
assign bus_sw_1d = ctl_sw_1d;
assign bus_sw_2u = ctl_sw_2u;
assign bus_sw_2d = ctl_sw_2d;
assign bus_sw_mask543_en = ctl_sw_mask543_en;
endmodule