module ethernet_mac_controller(  
    input wire clk,  
    input wire rst,  
    input wire data_available,  
    output reg [1:0] state // 0: IDLE, 1: TRANSMIT, 2: RECEIVE  
);  
    // Define state encoding  
    localparam IDLE = 2'b00;  
    localparam TRANSMIT = 2'b01;  
    localparam RECEIVE = 2'b10;  

    // State transition logic  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (data_available)  
                        state <= TRANSMIT;  
                end  
                TRANSMIT: begin  
                    // Logic to transmit data (for example, after a fixed cycle)  
                    state <= RECEIVE;  
                end  
                RECEIVE: begin  
                    // Logic to receive data  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule