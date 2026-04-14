module robot_location_fsm(  
    input clk,  
    input reset,  
    input [1:0] move,  // 00: Up, 01: Down, 10: Left, 11: Right  
    output reg [1:0] location  // 00: (0,0), 01: (0,1), 10: (1,0), 11: (1,1)  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            location <= 2'b00;  // Start at (0,0)  
        end else begin  
            case (move)  
                2'b00: if(location[1] == 0) location <= {1'b0, location[0]}; // Up  
                2'b01: if(location[1] == 0) location <= {1'b1, location[0]}; // Down  
                2'b10: if(location[0] == 0) location <= {location[1], 1'b0}; // Left  
                2'b11: if(location[0] == 1) location <= {location[1], 1'b1}; // Right  
                default: location <= location;  
            endcase  
        end  
    end  
endmodule