module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input valid,  
    output reg status  
);  

    reg [7:0] packet_buffer;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            status <= 0;  
            packet_buffer <= 0;  
        end else if (valid) begin  
            packet_buffer <= data_in;  
            if (packet_buffer == 8'hFF) begin  // Example condition for error  
                status <= 1;  // Error  
            end else begin  
                status <= 0;  // Received successfully  
            end  
        end  
    end  
endmodule