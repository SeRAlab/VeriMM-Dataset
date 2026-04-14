module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input start_transmit,  
    input start_receive,  
    output reg [1:0] state, // 00: IDLE, 01: TRANSMIT, 10: RECEIVE  
    output reg [7:0] data_out // Data to be transmitted  
);  
    // State encoding  
    localparam IDLE = 2'b00;  
    localparam TRANSMIT = 2'b01;  
    localparam RECEIVE = 2'b10;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            data_out <= 8'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_transmit) begin  
                        state <= TRANSMIT;  
                        data_out <= 8'hA5; // Example data  
                    end else if (start_receive) begin  
                        state <= RECEIVE;  
                    end  
                end  
                TRANSMIT: begin  
                    // Transmission logic (simplified)  
                    state <= IDLE; // Go back to IDLE after transmission  
                end  
                RECEIVE: begin  
                    // Reception logic (simplified)  
                    state <= IDLE; // Go back to IDLE after receiving  
                end  
            endcase  
        end  
    end  
endmodule