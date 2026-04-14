module decoder_5_to_32 (input [4:0] binary_input, output reg [31:0] decoded_output);  
    always @(*) begin  
        decoded_output = 32'b0; // Set all outputs low  
        case (binary_input)  
            5'd0: decoded_output = 32'b00000000000000000000000000000001;  
            5'd1: decoded_output = 32'b00000000000000000000000000000010;  
            5'd2: decoded_output = 32'b00000000000000000000000000000100;  
            5'd3: decoded_output = 32'b00000000000000000000000000001000;  
            5'd4: decoded_output = 32'b00000000000000000000000000010000;  
            5'd5: decoded_output = 32'b00000000000000000000000000100000;  
            5'd6: decoded_output = 32'b00000000000000000000000001000000;  
            5'd7: decoded_output = 32'b00000000000000000000000010000000;  
            5'd8: decoded_output = 32'b00000000000000000000000100000000;  
            5'd9: decoded_output = 32'b00000000000000000000001000000000;  
            5'd10: decoded_output = 32'b00000000000000000000010000000000;  
            5'd11: decoded_output = 32'b00000000000000000000100000000000;  
            5'd12: decoded_output = 32'b00000000000000000001000000000000;  
            5'd13: decoded_output = 32'b00000000000000000010000000000000;  
            5'd14: decoded_output = 32'b00000000000000000100000000000000;  
            5'd15: decoded_output = 32'b00000000000000001000000000000000;  
            5'd16: decoded_output = 32'b00000000000000010000000000000000;  
            5'd17: decoded_output = 32'b00000000000000100000000000000000;  
            5'd18: decoded_output = 32'b00000000000001000000000000000000;  
            5'd19: decoded_output = 32'b00000000000010000000000000000000;  
            5'd20: decoded_output = 32'b00000000000100000000000000000000;  
            5'd21: decoded_output = 32'b00000000001000000000000000000000;  
            5'd22: decoded_output = 32'b00000000010000000000000000000000;  
            5'd23: decoded_output = 32'b00000000100000000000000000000000;  
            5'd24: decoded_output = 32'b00000001000000000000000000000000;  
            5'd25: decoded_output = 32'b00000010000000000000000000000000;  
            5'd26: decoded_output = 32'b00000100000000000000000000000000;  
            5'd27: decoded_output = 32'b00001000000000000000000000000000;  
            5'd28: decoded_output = 32'b00010000000000000000000000000000;  
            5'd29: decoded_output = 32'b00100000000000000000000000000000;  
            5'd30: decoded_output = 32'b01000000000000000000000000000000;  
            5'd31: decoded_output = 32'b10000000000000000000000000000000;  
            default: decoded_output = 32'b0; // Invalid input case  
        endcase  
    end  
endmodule