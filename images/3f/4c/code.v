module sd_card_controller(  
    input clk,  
    input rst,  
    input [1:0] cmd,  // 00: No Command, 01: Read, 10: Write, 11: Reset  
    output reg [1:0] state,  // 00: IDLE, 01: READ, 10: WRITE, 11: ERROR  
    output reg success  
);  
    // State Encoding  
    localparam IDLE = 2'b00;  
    localparam READ = 2'b01;  
    localparam WRITE = 2'b10;  
    localparam ERROR = 2'b11;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            success <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (cmd == 2'b01) begin  // Read command  
                        state <= READ;  
                        success <= 1;  
                    end else if (cmd == 2'b10) begin  // Write command  
                        state <= WRITE;  
                        success <= 1;  
                    end else if (cmd == 2'b11) begin  // Reset command  
                        state <= IDLE;  
                        success <= 0;  
                    end else begin  
                        success <= 0;  
                    end  
                end  
                READ: begin  
                    state <= IDLE;  // Transition back to IDLE after READ  
                    success <= 1;  
                end  
                WRITE: begin  
                    state <= IDLE;  // Transition back to IDLE after WRITE  
                    success <= 1;  
                end  
                ERROR: begin  
                    state <= IDLE;  // Reset to IDLE on ERROR  
                    success <= 0;  
                end  
            endcase  
        end  
    end  
endmodule