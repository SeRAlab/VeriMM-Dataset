module ethernet_mac_controller (  
    input clk,  
    input reset,  
    input start_receive,  
    input frame_received,  
    input process_done,  
    input transmit_done,  
    output reg [1:0] current_state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              RECEIVE = 2'b01,  
              PROCESS = 2'b10,  
              TRANSMIT = 2'b11;  

    // State register  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_receive)  
                        state <= RECEIVE;  
                end  
                RECEIVE: begin  
                    if (frame_received)  
                        state <= PROCESS;  
                end  
                PROCESS: begin  
                    if (process_done)  
                        state <= TRANSMIT;  
                end  
                TRANSMIT: begin  
                    if (transmit_done)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  

    // Output current state  
    always @(state) begin  
        current_state <= state;  
    end  
endmodule