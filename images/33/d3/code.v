module data_forwarding_unit(  
    input wire [31:0] data1,  
    input wire [31:0] data2,  
    input wire sel,  
    output wire [31:0] forwarded_data  
);  
    assign forwarded_data = (sel) ? data2 : data1;  
endmodule