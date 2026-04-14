module pcie_controller (  
    input wire clk,  
    input wire rst_n,  
    input wire start,  
    input wire error,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00,  
              ACTIVE = 2'b01,  
              ERROR_STATE = 2'b10;  
  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= ACTIVE;  
                ACTIVE: if (error) state <= IDLE;  
                ERROR_STATE: if (error) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule