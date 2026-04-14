module current_sensor(  
    input [2:0] current_in,  
    output reg [1:0] current_out  
);  
    always @(*) begin  
        case (current_in)  
            3'b000, 3'b001, 3'b010: current_out = 2'b00; // 0 to 2  
            3'b011, 3'b100, 3'b101: current_out = 2'b01; // 3 to 5  
            3'b110, 3'b111: current_out = 2'b10; // 6 to 7  
            default: current_out = 2'b11; // 8 to 10 and overflow  
        endcase  
    end  
endmodule