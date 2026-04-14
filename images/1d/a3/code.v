module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input send_frame,  
    output reg [7:0] frame_out,  
    output reg frame_sent,  
    output reg frame_received  
);  

    reg [3:0] state;  
    reg [7:0] frame_buffer;  
    parameter IDLE = 0, SEND = 1, RECEIVE = 2;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            frame_out <= 8'b0;  
            frame_sent <= 0;  
            frame_received <= 0;  
            frame_buffer <= 8'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    frame_sent <= 0;  
                    frame_received <= 0;  
                    if (send_frame) begin  
                        frame_buffer <= data_in;  
                        state <= SEND;  
                    end  
                end  
                SEND: begin  
                    frame_out <= frame_buffer;  
                    frame_sent <= 1;  
                    state <= IDLE;  
                end  
                RECEIVE: begin  
                    // Reception logic would go here (for simplicity, omitted)  
                end  
            endcase  
        end  
    end  
endmodule