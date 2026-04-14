module mux_16bit (  
    input [15:0] data0,  
    input [15:0] data1,  
    input sel,  
    output [15:0] out  
);  
    assign out = (sel) ? data1 : data0;  
endmodule