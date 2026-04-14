module ethernet_mac_controller(  
    input clk,  
    input rst,  
    input start_transmit,  
    input receive_data,  
    output reg [1:0] state,  
    output reg transmit_enable,  
    output reg receive_enable  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               TRANSMIT = 2'b01,  
               RECEIVE = 2'b10;  

    // State transition  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            transmit_enable <= 0;  
            receive_enable <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    transmit_enable <= 0;  
                    receive_enable <= 0;  
                    if (start_transmit) begin  
                        state <= TRANSMIT;  
                    end else if (receive_data) begin  
                        state <= RECEIVE;  
                    end  
                end  
                TRANSMIT: begin  
                    transmit_enable <= 1;  
                    receive_enable <= 0;  
                    state <= IDLE;  // Go back to IDLE after transmit  
                end  
                RECEIVE: begin  
                    transmit_enable <= 0;  
                    receive_enable <= 1;  
                    state <= IDLE;  // Go back to IDLE after receive  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule