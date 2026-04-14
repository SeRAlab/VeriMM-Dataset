module wifi_status_indicator(input [4:0] signal_strength, input [4:0] connection_status, output reg [4:0] wifi_status);  
    always @(*) begin  
        if (connection_status == 1) begin  
            if (signal_strength > 5'd10)  
                wifi_status = 5'b11111; // Connected with strong signal  
            else  
                wifi_status = 5'b00001; // Connected with weak signal  
        end else begin  
            wifi_status = 5'b00000; // Disconnected  
        end  
    end  
endmodule