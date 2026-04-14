module data_bus_controller(  
    input wire [7:0] data_in1,  
    input wire [7:0] data_in2,  
    input wire control,  
    output reg [7:0] data_out  
);  

always @(*) begin  
    if (control)  
        data_out = data_in1;  
    else  
        data_out = data_in2;  
end  
endmodule