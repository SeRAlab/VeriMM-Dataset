module ethernet_mac_controller (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire start_tx,  
    output reg [7:0] data_out,  
    output reg tx_done  
);  

    reg [7:0] tx_data;  
    reg tx_active;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b0;  
            tx_done <= 1'b0;  
            tx_active <= 1'b0;  
        end else begin  
            if (start_tx && !tx_active) begin  
                tx_data <= data_in;  
                tx_active <= 1'b1;  
            end  
            if (tx_active) begin  
                data_out <= tx_data;  
                tx_done <= 1'b1;  
                tx_active <= 1'b0;  
            end else begin  
                tx_done <= 1'b0;  
            end  
        end  
    end  
endmodule