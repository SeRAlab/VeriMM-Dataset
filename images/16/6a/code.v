module pcie_endpoint_controller(  
    input wire clk,  
    input wire rst,  
    input wire [1:0] command,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (command == 2'b01)  
                        state <= READ;  
                    else if (command == 2'b10)  
                        state <= WRITE;  
                end  
                READ: begin  
                    state <= IDLE;  // Return to IDLE after READ  
                end  
                WRITE: begin  
                    state <= IDLE;  // Return to IDLE after WRITE  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule