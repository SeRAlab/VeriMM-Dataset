module voltage_sensor(  
    input [4:0] voltage_in,  
    output reg [1:0] status  
);  
    always @(*) begin  
        if (voltage_in > 31)  
            status = 2'b11; // Invalid input  
        else if (voltage_in < 10)  
            status = 2'b00; // Below threshold  
        else  
            status = 2'b01; // At or above threshold  
    end  
endmodule