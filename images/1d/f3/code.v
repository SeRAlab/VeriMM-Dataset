module eth_mac_controller (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] data_in,  
    output reg ack  
);  
    reg [7:0] data_buffer;  
    reg processing;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ack <= 0;  
            processing <= 0;  
            data_buffer <= 0;  
        end else if (enable) begin  
            data_buffer <= data_in;  
            processing <= 1;  
            ack <= 0;  
        end else if (processing) begin  
            // Simulate processing time  
            ack <= 1;  
            processing <= 0;  
        end  
    end  
endmodule