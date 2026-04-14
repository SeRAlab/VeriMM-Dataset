module current_sensor(  
    input [4:0] current_level,  
    output reg [2:0] status  
);  
always @(*) begin  
    if (current_level <= 5'd10)  
        status = 3'b000; // Low  
    else if (current_level <= 5'd20)  
        status = 3'b001; // Normal  
    else if (current_level <= 5'd30)  
        status = 3'b010; // High  
    else  
        status = 3'b011; // Overload  
end  
endmodule