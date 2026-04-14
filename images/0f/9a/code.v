module dvfs_controller(  
    input [2:0] voltage,  
    output reg [1:0] frequency  
);  
    always @(*) begin  
        case (voltage)  
            3'b000: frequency = 2'b00;  
            3'b001: frequency = 2'b01;  
            3'b010: frequency = 2'b10;  
            3'b011, 3'b100: frequency = 2'b11;  
            3'b101, 3'b110: frequency = 2'b11;  
            3'b111: frequency = 2'b00;  
            default: frequency = 2'b00;  
        endcase  
    end  
endmodule