module ethernet_mac_controller(  
    input wire clk,  
    input wire tx_enable,  
    input wire rx_enable,  
    input wire [7:0] tx_data,  
    output reg [7:0] rx_data  
);  
    reg [7:0] tx_buffer;  

    always @(posedge clk) begin  
        if (tx_enable) begin  
            tx_buffer <= tx_data;  
        end  
    end  

    always @(posedge clk) begin  
        if (rx_enable) begin  
            rx_data <= tx_buffer;  
        end  
    end  
endmodule