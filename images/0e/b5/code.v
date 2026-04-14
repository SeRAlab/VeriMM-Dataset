module gpio_controller(  
    input [4:0] data_in,  
    input enable,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        if (enable)  
            data_out = data_in;  
        else  
            data_out = 5'b00000;  
    end  
endmodule