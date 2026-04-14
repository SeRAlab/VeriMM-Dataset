module gpio_controller(  
    input [7:0] data_in,  
    input enable,  
    output reg [7:0] data_out  
);  
  
always @(*) begin  
    if (enable)  
        data_out = data_in;  
    else  
        data_out = 8'b00000000;  
end  
endmodule