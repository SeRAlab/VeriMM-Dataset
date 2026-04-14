module dvfs_controller(  
    input [1:0] temperature,  
    output reg [1:0] frequency  
);  
    always @(*) begin  
        case (temperature)  
            2'b00: frequency = 2'b00; // Low temperature -> Low frequency  
            2'b01: frequency = 2'b01; // Medium temperature -> Medium frequency  
            2'b10: frequency = 2'b10; // High temperature -> High frequency  
            2'b11: frequency = 2'b11; // Very high temperature -> Maximum frequency  
            default: frequency = 2'b00; // Default case  
        endcase  
    end  
endmodule