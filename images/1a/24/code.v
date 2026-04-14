module nvme_controller (  
    input wire clk,  
    input wire reset,  
    input wire read_cmd,  
    input wire busy,  
    input wire done,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00;  
    localparam READ = 2'b01;  
    localparam DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (read_cmd)  
                        state <= READ;  
                end  
                READ: begin  
                    if (done)  
                        state <= DONE;  
                end  
                DONE: begin  
                    if (!read_cmd)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule