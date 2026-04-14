module ARQReceiver (  
    input wire clk,  
    input wire enable,  
    input wire [7:0] data,  
    input wire [7:0] checksum,  
    output reg ack,  
    output reg nack,  
    output reg valid  
);  

reg [7:0] calculated_checksum;  

always @(posedge clk) begin  
    if (enable) begin  
        // Simple checksum calculation (e.g., sum of data bytes)  
        calculated_checksum <= data + 8'b00000001; // Just a simple increment for example  
        if (calculated_checksum == checksum) begin  
            valid <= 1;  
            ack <= 1;  
            nack <= 0;  
        end else begin  
            valid <= 0;  
            ack <= 0;  
            nack <= 1;  
        end  
    end  
end  

endmodule