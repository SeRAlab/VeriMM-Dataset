module pcie_controller (  
    input clk,  
    input reset,  
    input start,  
    input req_valid,  
    input req_ready,  
    input resp_done,  
    output reg [1:0] state  
);  
  
    // State Encoding  
    parameter IDLE = 2'b00, REQUEST = 2'b01, RESPONSE = 2'b10;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= REQUEST;  
                end  
                REQUEST: begin  
                    if (req_valid && req_ready)  
                        state <= RESPONSE;  
                end  
                RESPONSE: begin  
                    if (resp_done)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule