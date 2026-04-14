module wifi_control(  
    input [2:0] state,  
    output reg [2:0] action  
);  
  
always @(*) begin  
    case (state)  
        3'b000: action = 3'b000; // Disconnected  
        3'b001: action = 3'b001; // Connecting  
        3'b010: action = 3'b010; // Connected  
        3'b011: action = 3'b011; // Disconnecting  
        3'b100: action = 3'b100; // Connection Error  
        default: action = 3'b000; // Idle  
    endcase  
end  
endmodule