module nvme_cmd_decoder(input [3:0] cmd, output reg [2:0] cmd_type);  
    always @(*) begin  
        case(cmd)  
            4'b0000: cmd_type = 3'b000;  // No Operation  
            4'b0001: cmd_type = 3'b001;  // Read  
            4'b0010: cmd_type = 3'b010;  // Write  
            4'b0011: cmd_type = 3'b011;  // Erase  
            4'b0100: cmd_type = 3'b100;  // Flush  
            4'b0101: cmd_type = 3'b101;  // Check Status  
            4'b0110: cmd_type = 3'b110;  // Get Features  
            4'b0111: cmd_type = 3'b111;  // Set Features  
            default: cmd_type = 3'b111;   // Invalid Command  
        endcase  
    end  
endmodule