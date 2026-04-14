module pcie_endpoint_controller (  
    input clk,  
    input reset,  
    input read_req,  
    input write_req,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00;  
    parameter READ = 2'b01;  
    parameter WRITE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (read_req)  
                        state <= READ;  
                    else if (write_req)  
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