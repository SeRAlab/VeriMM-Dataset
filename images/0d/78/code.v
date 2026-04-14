module SimpleHMAC (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] key,  
    input [7:0] message,  
    output reg [7:0] hash,  
    output reg valid  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, PROCESS = 2'b01, OUTPUT = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            hash <= 8'b0;  
            valid <= 0;  
        end  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= PROCESS;  
                end  
                PROCESS: begin  
                    hash <= key ^ message; // Simple hash operation  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    valid <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule