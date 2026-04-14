module sata_controller (  
    input wire clk,  
    input wire rst,  
    input wire send,  
    input wire receive,  
    output reg [1:0] state  
);  
    // State Encoding  
    localparam IDLE = 2'b00;  
    localparam SEND = 2'b01;  
    localparam RECEIVE = 2'b10;  
    
    // Sequential Logic  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send)  
                        state <= SEND;  
                    else if (receive)  
                        state <= RECEIVE;  
                end  
                SEND: begin  
                    if (!send)  
                        state <= IDLE;  
                end  
                RECEIVE: begin  
                    if (!receive)  
                        state <= IDLE;  
                end  
                default: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule