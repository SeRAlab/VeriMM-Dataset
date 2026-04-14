module ethernet_mac_controller (  
    input wire clk,  
    input wire start_tx,  
    input wire [7:0] data_in,  
    output reg tx_valid,  
    output reg [7:0] tx_data  
);  

    reg [2:0] state;  
    parameter IDLE = 3'b000,  
              TRANSMIT = 3'b001,  
              WAIT = 3'b010;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                tx_valid <= 0;  
                if (start_tx) begin  
                    tx_data <= data_in;  
                    tx_valid <= 1;  
                    state <= TRANSMIT;  
                end  
            end  
            TRANSMIT: begin  
                // Continue to transmit data  
                if (tx_valid) begin  
                    state <= WAIT;  
                end  
            end  
            WAIT: begin  
                // Wait for next start signal  
                if (!start_tx) begin  
                    tx_valid <= 0;  
                    state <= IDLE;  
                end  
            end  
        endcase  
    end  
endmodule