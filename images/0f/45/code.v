module ethernet_mac_controller(  
    input wire clk,  
    input wire reset,  
    input wire transmit,  
    input wire [7:0] frame_data,  
    output reg tx_done,  
    output reg [7:0] transmitted_frame  
);  

    reg [7:0] frame_buffer;  
    reg [2:0] state;  

    parameter IDLE = 3'b000,  
              STORE = 3'b001,  
              TRANSMIT = 3'b010,  
              DONE = 3'b011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            tx_done <= 0;  
            transmitted_frame <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (transmit) begin  
                        state <= STORE;  
                    end  
                end  
                STORE: begin  
                    frame_buffer <= frame_data;  
                    state <= TRANSMIT;  
                end  
                TRANSMIT: begin  
                    transmitted_frame <= frame_buffer;  
                    tx_done <= 1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    tx_done <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule