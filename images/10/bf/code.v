module ethernet_mac_controller (  
    input wire clk,  
    input wire reset,  
    input wire tx_req,  
    input wire ack,  
    output reg [1:0] state  
);  

    // State Encoding  
    localparam IDLE         = 2'b00;  
    localparam TRANSMIT     = 2'b01;  
    localparam WAIT_FOR_ACK = 2'b10;  

    // Sequential Logic - State Transition  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (tx_req) begin  
                        state <= TRANSMIT;  
                    end  
                end  
                TRANSMIT: begin  
                    // Simulate transmit process  
                    state <= WAIT_FOR_ACK;  
                end  
                WAIT_FOR_ACK: begin  
                    if (ack) begin  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule