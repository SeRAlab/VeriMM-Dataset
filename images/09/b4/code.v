module temperature_sensor(input [2:0] temp_input, output reg [2:0] status_output);  
    always @(*) begin  
        case(temp_input)  
            3'b000: status_output = 3'b000; // temp < 2  
            3'b001: status_output = 3'b000; // temp < 2  
            3'b010: status_output = 3'b001; // temp 2-4  
            3'b011: status_output = 3'b001; // temp 2-4  
            3'b100: status_output = 3'b001; // temp 2-4  
            3'b101: status_output = 3'b010; // temp 5-6  
            3'b110: status_output = 3'b010; // temp 5-6  
            3'b111: status_output = 3'b011; // temp == 7  
            default: status_output = 3'b000;  
        endcase  
    end  
endmodule