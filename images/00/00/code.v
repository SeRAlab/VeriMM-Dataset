module pcie_controller (  
    input clk,  
    input rst_n,  
    input request,  
    input [7:0] request_data,  
    output reg response,  
    output reg response_data  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, PROCESS = 2'b01, RESPOND = 2'b10;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            state <= IDLE;  
            response <= 0;  
            response_data <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (request) begin  
                        state <= PROCESS;  
                    end  
                end  
                PROCESS: begin  
                    // Simulating processing time  
                    if (request_data >= 8'd128) begin  
                        response_data <= 1;  // success  
                    end else begin  
                        response_data <= 0;  // failure  
                    end  
                    state <= RESPOND;  
                end  
                RESPOND: begin  
                    response <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule