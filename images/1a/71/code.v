module nvme_controller (  
    input wire clk,  
    input wire rst,  
    input wire read_cmd,  
    input wire write_cmd,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               READ = 2'b01,  
               WRITE = 2'b10;  
               
    // State transition logic  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (read_cmd)  
                        state <= READ;  
                    else if (write_cmd)  
                        state <= WRITE;  
                end  
                READ:  
                    state <= IDLE;  
                WRITE:  
                    state <= IDLE;  
                default:  
                    state <= IDLE;  
            endcase  
        end  
    end  
endmodule